$MainName = "<temperature_place_name>"

$Uri = "<uri_web_page>"

$Web = Invoke-WebRequest -Uri $Uri

$Tcur = [int]$Web.RawContent.Split(" = ")[24]

$Tmax = 24

$Date = Get-Date -Format "yyyyMMdd"

$Time = Get-Date -Format "HH:mm:ss"

if ($Tcur -ge $Tmax) {

    $MessageBody = "<html><body style='font-family:Geneva, Arial, Helvetica, sans-serif;font-size:0.8em'><p>Температура в $MainName <b>$Tcur град. C</b> (Tmax = $Tmax).</p></body></html>"

    $MessageTo = "<email>"

    $MessageFrom = "WarningTemperature@$MainName"

    $MessageSMTPServer = "<smtp_server>"

    $MessageSubject = "$MainName. Превышение температуры. $DT"

    Send-MailMessage -BodyAsHtml -Body $MessageBody -From $MessageFrom -To $MessageTo -SmtpServer $MessageSMTPServer -Subject $MessageSubject -Encoding Unicode

}

if(!(Get-Item -LiteralPath $PSScriptRoot\$MainName)) {New-Item -Path $PSScriptRoot -Name $MainName -ItemType Directory}

$Out = "$Time;$Tcur"

$Path = "$PSScriptRoot\$MainName\$Date.csv"

Out-File -InputObject $Out -LiteralPath $Path -Encoding utf8 -Append