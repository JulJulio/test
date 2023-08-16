$logdir = "C:\temp"
$JobBaseName = "NoMpSigStub1"	# mantenere questo nome breve e sincronizzarlo con il lanciatore
$Computername = (dir env:computername).value
$Dominion = (Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select Domain).domain
$datteUTC = (Get-Date).ToUniversalTime() 
$logdatte = get-date ($datteUTC) -Format "yyyyMMdd-HHmmssZ"
$logname  = $logdir + "\" + $JobBaseName + "_" + $Dominion + "-" +$Computername + "-" + $logdatte + ".log"
$LogUninst1 = $logname + "StdOut.txt"
$LogUninst2 = $logname + "StdErr.txt"
$MyExitCode = 0

$BaseDir = (dir env:windir).value	# C:\windows   termina_senza_backslash
$FileDir = $BaseDir + "\system32"
$UninstFile = $FileDir + "\MpSigStub.exe"

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
	  OutVideo($datte + " C:\temp created")		#si suppone non dia errori
	}


$datte = get-date -Format "yyyyMMdd HH:mm:ss K"	
If (Test-path -path $FileDir){
	  OutVideo($datte + " RarDir Found!")
	$datte = get-date -Format "yyyyMMdd HH:mm:ss K"	
	If (Test-path -path ($UninstFile))
	  {
	      OutVideo($datte + " Undesired File Found!")

		# se uso il -wait, exitus e' praticamente vuoto. Opto per lo sleep		
	      ### $Exitus = start-process -WorkingDirectory $FileDir -FilePath $UninstFile -ArgumentList "/S" -PassThru -NoNewWindow -RedirectStandardError $LogUninst2 -RedirectStandardOutput $LogUninst1
	      $Exitus = remove-item -path $UninstFile -force
	      $datte = get-date -Format "yyyyMMdd HH:mm:ss K"	
	      OutFile($Exitus | fl)
	      OutFile($datte + " Operation completed with the previous messages, if exist")			

		Start-Sleep 5
		If (Test-path -path ($UninstFile))
			{
			 OutVideo($datte + " Undesired file not removed. Failed")
			 $MyExitCode = 77004
			} 
			else
			{ 
			OutVideo($datte + " Undesired file removed successfully!")
			}

	  }
	  else #di uninstall
	  {
	  OutVideo($datte + " Undesired file not Found")
	  $MyExitCode = 77003
	  }
	}
	else	#di FileDir
	{
	OutVideo($datte + " FileDIr not Found")
	 $MyExitCode = 77001
	}

OutVideo($datte + " End of script with code " + $MyExitCode)
Exit $MyExitCode

