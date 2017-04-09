$x = 0
$width = (get-host).UI.RawUI.MaxWindowSize.Width
$show = @()
$g = ( "2" , "10" )
$b = ( "3" , "11" )
$color = Read-Host "Pick color, green or blue (g for green, b for blue):"
while ( 1 -eq 1 ) {
    while ( $x -lt $width ) {
        #$show+=[char](Get-Random -Minimum 32 -Maximum 127)
        $show += ( Get-Random -Minimum 0 -Maximum 2 )
        $x ++
        if( $x -gt $width-1 ) {
            $y = 0
            while ( $y -lt $width - 30 ) {
                $show[ ( Get-Random -Minimum 0 -Maximum ( $width ) ) ] = " "
                $y ++
            }
        }
    }
    if($color -eq "g"){
        Write-Host $show[ ( Get-Random -Minimum 0 -Maximum ( $width-1 ) ) ]" " -BackgroundColor black -ForegroundColor  ( Get-Random -inputobject $g ) -NoNewline
    }
    else{
        Write-Host $show[ ( Get-Random -Minimum 0 -Maximum ( $width-1 ) ) ]" " -BackgroundColor black -ForegroundColor  ( Get-Random -inputobject $b ) -NoNewline
    }
}
