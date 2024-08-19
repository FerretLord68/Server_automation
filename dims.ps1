$PATH_1 = "C:\Users\frede\Documents\test"
$i = 0
$LOGFILE = "C:\Users\frede\Documents\test\dims.log"
$PATH_2 = "$PATH_1\new-test"


# Starting the logging of the script
Start-Transcript -path $LOGFILE -Append

# Starting the creation of the files and checks if they exists
echo "Starting the creation of the different files :)"
do {
    $FILENAME_1 = "$PATH_1\frank$i.txt"
    $TEST_FILE_1 = Test-Path $FILENAME_1
    if (-not($TEST_FILE_1)){
        New-Item $FILENAME_1
    } 
    
    else {
        echo "The file already exists :)"
    }

    $i ++
}while ($i -lt 10)

# makes array of all files in $PATH_1
$TXT_ARRAY = GCI $PATH_1 -file | Where-Object {$_.Extension -eq ".txt"}

# Checks if the sub-dir exitest, and if not it creates the sub-dir
$TEST_PATH_2 = Test-Path $PATH_2
if ($TEST_PATH_2 -eq $false){
    mkdir $PATH_2
}
else {
    echo "Dir allready existest"
}

#copies alle files from perent-dir to sub-dir
foreach ($FILE in $TXT_ARRAY){
    cp $PATH_1\$FILE $PATH_2
}

# Makes new array for sub-dir files
$TXT_ARRAY_2 = GCI $PATH_2 -file | Where-Object {$_.Extension -eq ".txt"}

$i = 0
# Renames the file extinsion
foreach ($file in $TXT_ARRAY_2){
    $FILENAME_2 = "$PATH_2\frank$i.bak"
    Rename-Item -path $PATH_2\$file -NewName $FILENAME_2
    $i ++
}



# Stops the logging
Stop-Transcript