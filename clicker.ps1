Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class CustomMouseClicker {
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern void mouse_event(uint dwFlags, int dx, int dy, int dwData, UIntPtr dwExtraInfo);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    public static void ClickLeftMouseButton(int x, int y) {
        mouse_event(0x0002, x, y, 0, UIntPtr.Zero); 
        mouse_event(0x0004, x, y, 0, UIntPtr.Zero); 
        mouse_event(0x0004, x, y, 0, UIntPtr.Zero); 
    }
}
"@

$previousCursorPosition = New-Object CustomMouseClicker+POINT
$previousCursorPosition.X = -1
$previousCursorPosition.Y = -1

while ($true) {
    $cursorPosition = New-Object CustomMouseClicker+POINT
    [CustomMouseClicker]::GetCursorPos([ref]$cursorPosition)

    $keyboardInputDetected = $false
    $mouseMovementDetected = $false

    $clickStartTime = Get-Date
    while ((Get-Date) -lt $clickStartTime.AddSeconds(10)) {
        $keyState = [System.Console]::KeyAvailable
        if ($keyState) {
            $keyboardInputDetected = $true
            Write-Host "Keyboard input detected."
            break
        }
        Start-Sleep -Milliseconds 100

        $currentCursorPosition = New-Object CustomMouseClicker+POINT
        [CustomMouseClicker]::GetCursorPos([ref]$currentCursorPosition)
        if ($currentCursorPosition.X -ne $cursorPosition.X -or $currentCursorPosition.Y -ne $cursorPosition.Y) {
            $mouseMovementDetected = $true
            Write-Host "Mouse movement detected."
            break
        }
    }

    if (-not $keyboardInputDetected -and -not $mouseMovementDetected) {
        [CustomMouseClicker]::ClickLeftMouseButton($cursorPosition.X, $cursorPosition.Y)
    }
    else {
        Write-Host "Clicking stopped due to keyboard input or mouse movement."
    }

    Start-Sleep -Seconds 10
}

