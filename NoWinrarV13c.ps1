#ho provato a lasciare ELSE su una riga da solo

$logdir = "C:\temp"
$JobBaseName = "NoRar05"	#mantenereIlNomeBreve e sincronizzarlo con il lanciatore
$Computername = (dir env:computername).value
$Dominion = (Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select Domain).domain
$datteUTC = (Get-Date).ToUniversalTime() 
$logdatte = get-date ($datteUTC) -Format "yyyyMMdd-HHmmssZ"
$logname  = $logdir + "\" + $JobBaseName + "_" + $Dominion + "-" +$Computername + "-" + $logdatte + ".log"
$LogUninst1 = $logname + "StdOut.txt"
$LogUninst2 = $logname + "StdErr.txt"


$Progfiles = (dir env:ProgramFiles).value	#termina_senza_backslash
$RarDir = $Progfiles + "\winrar"
$UninstFile = $RarDir + "\uninstall.exe"

##############################################
function OutVideo ($message1) {
	write-host $message1
	Outfile($message1)
}

function OutFile ($message2) {
	out-file -append -filepath $logname -Width 200 -InputObject $message2
}
##############################################


$datte = get-date -Format "yyyyMMdd HH:mm:ss K"	
If (Test-path -path "C:\temp"){
	  OutFile($datte + " C:\temp already exists")
	}
	else
	{
	  md c:\temp
	  OutVideo($datte + " C:\temp created")
	}


$datte = get-date -Format "yyyyMMdd HH:mm:ss K"	
If (Test-path -path $RarDir){
	  OutVideo($datte + " RarDir Found!")
	$datte = get-date -Format "yyyyMMdd HH:mm:ss K"	
	If (Test-path -path ($RarDir+"\uninstall.exe"))
	  {
	      OutVideo($datte + " Rar Uninstall Found!")

		# se uso il -wait, exitus e' praticamente vuoto. Opto per lo sleep		
	      $Exitus = start-process -WorkingDirectory $RarDir -FilePath $UninstFile -ArgumentList "/S" -PassThru -NoNewWindow -RedirectStandardError $LogUninst2 -RedirectStandardOutput $LogUninst1
	      OutFile($Exitus | fl)
	      OutFile("Operation completed with the previous messages, if exist")			

		Start-Sleep 5
		If (Test-path -path ($RarDir+"\uninstall.exe"))
			{
			 OutVideo($datte + " Rar Uninstallation Failed")
			} 
			else
			{ 
			OutVideo($datte + " Rar Uninstallation completed successfully!")
			}

	  }
	  else #di uninstall
	  {
	  OutVideo($datte + " Rar Uninstall not Found")
	  }
	}
	else	#di rardir
	{
	OutVideo($datte + " RarDir not Found")
	}

OutVideo($datte + " End of script")

