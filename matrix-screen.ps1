$x=0
$show=@()
while(1 -eq 1){
    if($x -lt 99){
        $show+=[char](Get-Random -Minimum 32 -Maximum 127)
        $x++
        if($x -gt 98){
            $y=0
            while($y -lt 65){
                $show[(Get-Random -Minimum 0 -Maximum ($x))]=" "
                $y++
            }
        }
    }
    else{
        Write-Host -NoNewline $show -BackgroundColor black -ForegroundColor Green
        Start-Sleep -Milliseconds 27
        $x=0
        $show=@()
        }
    }
