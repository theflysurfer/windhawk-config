// ==WindhawkMod==
// @id              explorer-transparent
// @name            Windows Explorer Transparent
// @description     Rend l'explorateur Windows complètement transparent
// @version         1.0
// @author          Custom
// @github
// @include         explorer.exe
// @compilerOptions -ldwmapi -luxtheme -lgdi32
// ==/WindhawkMod==

// ==WindhawkModReadme==
/*
# Windows Explorer Transparent

Ce mod rend l'explorateur Windows complètement transparent en modifiant les attributs DWM
et en appliquant des styles visuels personnalisés.

## Fonctionnalités
- Transparence complète de l'arrière-plan de l'explorateur
- Support de l'effet de flou (optionnel)
- Compatible Windows 10 et 11

## Configuration
Ajustez le niveau de transparence dans les paramètres :
- 0 = Complètement opaque
- 255 = Complètement transparent
*/
// ==/WindhawkModReadme==

// ==WindhawkModSettings==
/*
- transparency: 200
  $name: Niveau de transparence
  $description: Niveau de transparence (0-255, 255 = complètement transparent)
- enableBlur: true
  $name: Activer le flou
  $description: Active l'effet de flou en arrière-plan
- transparentBackground: true
  $name: Arrière-plan transparent
  $description: Rend l'arrière-plan de l'explorateur transparent
*/
// ==/WindhawkModSettings==

#include <windows.h>
#include <dwmapi.h>
#include <uxtheme.h>

struct {
    int transparency;
    bool enableBlur;
    bool transparentBackground;
} settings;

void LoadSettings() {
    settings.transparency = Wh_GetIntSetting(L"transparency");
    settings.enableBlur = Wh_GetIntSetting(L"enableBlur");
    settings.transparentBackground = Wh_GetIntSetting(L"transparentBackground");
}

void ApplyTransparency(HWND hwnd) {
    if (!hwnd || !IsWindow(hwnd)) {
        return;
    }

    // DWM Blur Behind
    if (settings.enableBlur) {
        DWM_BLURBEHIND bb = {0};
        bb.dwFlags = DWM_BB_ENABLE | DWM_BB_BLURREGION;
        bb.fEnable = TRUE;
        bb.hRgnBlur = CreateRectRgn(0, 0, -1, -1);
        DwmEnableBlurBehindWindow(hwnd, &bb);
        if (bb.hRgnBlur) {
            DeleteObject(bb.hRgnBlur);
        }
    }

    // Transparence de la fenêtre
    if (settings.transparentBackground) {
        // Activer la composition DWM
        BOOL enable = TRUE;
        DwmEnableComposition(enable);

        // Étendre le cadre dans la zone client
        MARGINS margins = {-1, -1, -1, -1};
        DwmExtendFrameIntoClientArea(hwnd, &margins);

        // Définir les attributs DWM pour Windows 11
        DWMNCRENDERINGPOLICY policy = DWMNCRP_ENABLED;
        DwmSetWindowAttribute(hwnd, DWMWA_NCRENDERING_POLICY, &policy, sizeof(policy));

        // Activer les bords arrondis (Windows 11)
        DWM_WINDOW_CORNER_PREFERENCE corner = DWMWCP_ROUND;
        DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &corner, sizeof(corner));

        // Activer la transparence
        BOOL useImmersiveDarkMode = TRUE;
        DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &useImmersiveDarkMode, sizeof(useImmersiveDarkMode));

        // Définir le style de fenêtre pour la transparence
        LONG_PTR exStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
        SetWindowLongPtr(hwnd, GWL_EXSTYLE, exStyle | WS_EX_LAYERED);

        // Appliquer la transparence
        SetLayeredWindowAttributes(hwnd, 0, 255 - settings.transparency, LWA_ALPHA);
    }
}

using CreateWindowExW_t = decltype(&CreateWindowExW);
CreateWindowExW_t CreateWindowExW_Original;
HWND WINAPI CreateWindowExW_Hook(
    DWORD dwExStyle,
    LPCWSTR lpClassName,
    LPCWSTR lpWindowName,
    DWORD dwStyle,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    HWND hWndParent,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam
) {
    HWND hwnd = CreateWindowExW_Original(
        dwExStyle, lpClassName, lpWindowName, dwStyle,
        X, Y, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam
    );

    if (hwnd) {
        // Vérifier si c'est une fenêtre de l'explorateur
        WCHAR className[256];
        if (GetClassNameW(hwnd, className, 256)) {
            if (wcscmp(className, L"CabinetWClass") == 0 ||
                wcscmp(className, L"ExplorerWClass") == 0 ||
                wcsstr(className, L"Shell") != nullptr) {
                ApplyTransparency(hwnd);
            }
        }
    }

    return hwnd;
}

// Hook pour attraper les fenêtres déjà existantes
BOOL CALLBACK EnumWindowsProc(HWND hwnd, LPARAM lParam) {
    DWORD processId;
    GetWindowThreadProcessId(hwnd, &processId);

    if (processId == GetCurrentProcessId()) {
        WCHAR className[256];
        if (GetClassNameW(hwnd, className, 256)) {
            if (wcscmp(className, L"CabinetWClass") == 0 ||
                wcscmp(className, L"ExplorerWClass") == 0 ||
                wcsstr(className, L"Shell") != nullptr) {
                ApplyTransparency(hwnd);
            }
        }
    }
    return TRUE;
}

BOOL Wh_ModInit() {
    Wh_Log(L"Initialisation du mod Explorer Transparent");

    LoadSettings();

    // Hook CreateWindowExW pour attraper les nouvelles fenêtres
    Wh_SetFunctionHook((void*)CreateWindowExW, (void*)CreateWindowExW_Hook, (void**)&CreateWindowExW_Original);

    // Appliquer aux fenêtres existantes
    EnumWindows(EnumWindowsProc, 0);

    return TRUE;
}

void Wh_ModUninit() {
    Wh_Log(L"Désinitialisation du mod Explorer Transparent");
}

void Wh_ModSettingsChanged() {
    Wh_Log(L"Paramètres modifiés, rechargement...");
    LoadSettings();

    // Réappliquer aux fenêtres existantes
    EnumWindows(EnumWindowsProc, 0);
}
