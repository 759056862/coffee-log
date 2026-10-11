Add-Type -AssemblyName System.Drawing

function New-Icon([int]$size, [string]$path, [bool]$maskable) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    $bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 28, 20, 14))
    $accent = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 212, 160, 94))
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 212, 160, 94), [single](26 * $size / 512.0))

    # 背景（maskable 留安全边距）
    if ($maskable) {
        $g.Clear([System.Drawing.Color]::Transparent)
        $pad = [int](0.2 * $size)
        $g.FillRectangle($bg, $pad, $pad, $size - 2*$pad, $size - 2*$pad)
    } else {
        $g.Clear([System.Drawing.Color]::FromArgb(255, 28, 20, 14))
    }

    $s = $size / 512.0
    # 杯身（圆角矩形近似：中段矩形 + 上下圆弧）
    $cx = 150.0; $cy = 190.0; $cw = 212.0; $ch = 130.0  # 512 基准坐标
    $g.FillPie($accent, [int]($cx*$s), [int]($cy*$s), [int]($cw*$s), [int]($ch*$s), 180, 180)
    $g.FillRectangle($accent, [int]($cx*$s), [int]($cy*$s) + [int]($ch*$s/2), [int]($cw*$s), [int]($ch*$s/2))
    # 把手
    $g.DrawArc($pen, [int](350*$s), [int](215*$s), [int](100*$s), [int](80*$s), 300, 180)
    # 杯托
    $g.DrawLine($pen, [int](120*$s), [int](385*$s), [int](392*$s), [int](385*$s))
    # 热气
    foreach ($sx in @(165, 256, 347)) {
        $g.DrawArc($pen, [int](($sx-20)*$s), [int](100*$s), [int](40*$s), [int](50*$s), 200, 280)
    }

    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$dir = "d:\My\Project\temp_20261011_01\coffee-log-pwa\icons"
New-Icon 192 "$dir\icon-192.png" $false
New-Icon 512 "$dir\icon-512.png" $false
New-Icon 512 "$dir\icon-512-maskable.png" $true
Write-Output "done"
