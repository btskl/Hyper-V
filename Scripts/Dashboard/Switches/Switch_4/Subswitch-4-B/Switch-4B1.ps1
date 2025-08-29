$optionschedule = Read-Host "Maak een keuze voor de schedule-options"
Switch ($optionschedule) {
    '1' #daily
    {
        
        # je kan zeggen once,dagelijks,wekelijks,startup,logon
        $time = Read-Host "Enter Time (bv. 10.00AM)"

        # als je zegt weekly moet je ook de dagen doorgeven wanneer    
        $trigger = New-ScheduledTaskTrigger -Daily -At $time
    }

    '2' #weekly
    {

    }   

    '3' #once
    {

    }   

    '4' #logon
    {

    }
}