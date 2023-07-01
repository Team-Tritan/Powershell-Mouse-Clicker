Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint cButtons, uint dwExtraInfo);
}

public class Clicker {
    public static void Main(string[] args) {
        while (true) {
            $cursorPosition = [System.Windows.Forms.Cursor]::Position
            $x = [System.Math]::Min([System.Math]::Max($cursorPosition.X, 0), [System.Windows.Forms.SystemInformation]::VirtualScreen.Width)
            $y = [System.Math]::Min([System.Math]::Max($cursorPosition.Y, 0), [System.Windows.Forms.SystemInformation]::VirtualScreen.Height)

            [User32]::mouse_event(0x02, $x, $y, 0, 0); 
            [User32]::mouse_event(0x04, $x, $y, 0, 0);  

            Start-Sleep -Seconds 10
        }
    }
}
"@

[Clicker]::Main()
