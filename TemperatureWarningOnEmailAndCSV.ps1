$MainName = "<sensor_place>"

$Uri = "sensor_uri"

$Web = Invoke-WebRequest -Uri $Uri

$Tcur = [double]$Web.RawContent.Split(" = ")[24]

$Tmax = 24

$Tmin = 5

$Date = Get-Date -Format "yyyyMMdd"

$Time = Get-Date -Format "HH:mm:ss"

if ($Tcur -ge $Tmax) {

    $MessageBody = "<html><body style='font-family:Geneva, Arial, Helvetica, sans-serif;font-size:1.5em'><div>Температура в $MainName <strong style='color: red'>$Tcur &degC</strong> (Tmax = $Tmax).</div></body></html>"

    $MessageSubject = "$MainName. Повышение температуры. $DT"

}

if ($Tcur -le $Tmin) {

    $MessageBody = "<html><body style='font-family:Geneva, Arial, Helvetica, sans-serif;font-size:1.5em'><div>Температура в $MainName <strong style='color: blue'>$Tcur &degC</strong> (Tmin = $Tmin).</div></body></html>"

    $MessageSubject = "$MainName. Понижение температуры. $DT"

}

if ($Tcur -ge $Tmax -or $Tcur -le $Tmin) {

    $MessageTo = "<email>"

    $MessageFrom = "WarningTemperature@$MainName"

    $MessageSMTPServer = "<smtp_server>"

    Send-MailMessage -BodyAsHtml -Body $MessageBody -From $MessageFrom -To $MessageTo -SmtpServer $MessageSMTPServer -Subject $MessageSubject -Encoding Unicode

}

if(!(Get-Item -LiteralPath $PSScriptRoot\$MainName)) {New-Item -Path $PSScriptRoot -Name $MainName -ItemType Directory}

$Out = "$Time;$Tcur"

$Path = "$PSScriptRoot\$MainName\$Date.csv"

Out-File -InputObject $Out -LiteralPath $Path -Encoding utf8 -Append
