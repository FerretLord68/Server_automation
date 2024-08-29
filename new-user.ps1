# Import-Module ActiveDirectory
# Hent data fra csv fil og gem i variable

Function Create-UsersFromCSV {
    # Initialize variable for the CSV file path
    $ADUsers = ""
    
    # Loop until a valid file path is provided
    do {
        $ADUsers = Read-Host "Where's the CSV file located?"
        if (-not (Test-Path -Path $ADUsers -PathType Leaf)) {
            Write-Host "Wrong path, please enter the path again."
        }
    } while (-not (Test-Path -Path $ADUsers -PathType Leaf))
    
    # If the file exists, continue with the script
    Write-Host "File found. Continuing with the script..."
    
    
    # $ADUsers = Import-Csv C:\Users\frede\Documents\test\brugerliste.csv -Delimiter ";"
    
    # Define UPN
    $UPN = "ezdubs.dk"
    
    # Loop igennem felterne i csv filen
    foreach ($User in $ADUsers) {
    
    
    
        $username = $User.firstname+"."+$User.lastname
    
        $Attributes = @{
        Enabled = $True
        ChangePasswordAtLogon = $True
        Name = $username
        SamAccountName=$username
        UserPrincipalName=$User.username+"@"+$UPN
        GivenName = $User.firstname
        SurName = $User.lastname
        Initials = $User.initials
        DisplayName = $User.lastname+","+$User.firstname
        Path = $User.ou
        EmailAddress = $User.email
        StreetAddress = $User.streetaddress
        City = $User.city
        PostalCode = $User.zipcode
        State = $User.state
        OfficePhone = $User.telephone
        Country = $User.Country
        Title = $User.jobtitle
        Company = $User.company
        Department = $User.department
        AccountPassword = (ConvertTo-secureString $user.Password -AsPlainText -Force)
        }
    
        $domain = "ezdubs.dk"
        $targetOU = Get-ADOrganizationalUnit -Searchbase $domain
        $targetOUExists = $ADUsers.ou | Where-Object { $_.ou -eq $targetOU }
    
        foreach ($ou in $ouList) {     
        if ($ouList | Where-Object { $_.ou -eq $ou.ou }) {
            Write-Host "OU '$($ou.ou)' exists in the CSV file."    
        } 
            else {         
                Write-Host "OU '$($ou.ou)' does not exist in the CSV file." } 
        }
    
        # Tjek om bruger er oprettet
        if (Get-ADUser - { SamAccountName -eq $username }) {
            
            # Hvis oprettet skriv en warning til skærm
            Write-Warning "En bruger med brugernavn $username er allerede oprettet i Active Directory."
        }
        else {
    
            # Opret bruger
            New-ADUser @Attributes
    
            # Hvis bruger er oprettet skriv
            Write-Host "Brugeren $username er oprettet." -ForegroundColor Cyan
        }
    }
    
    # Read-Host -Prompt "Tryk på en tast for at afslutte"
    }

# Define the function to delete an AD user
function Delete-UserOneByOne {
    # Import the Active Directory module
Import-Module ActiveDirectory



    # Prompt the user for the username to delete
    $userToDelete = Read-Host -Prompt "Enter the username of the AD user to delete"

    # Check if the user exists in AD
    $user = Get-ADUser -Identity $userToDelete -ErrorAction SilentlyContinue

    if ($user) {
        # Confirm deletion with the user
        $confirmation = Read-Host -Prompt "Are you sure you want to delete user $userToDelete? (Y/N)"
        
        if ($confirmation -eq 'Y') {
            # Delete the user from AD
            Remove-ADUser -Identity $userToDelete -Confirm:$false
            Write-Host "User $userToDelete has been deleted successfully."
        } else {
            Write-Host "Operation cancelled. User $userToDelete has not been deleted."
        }
    } else {
        Write-Host "User $userToDelete does not exist in Active Directory."
    }
}

# Function to display the menu
function Show-Menu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " Active Directory Management"
    Write-Host "==============================="
    Write-Host "1. Create users via .csv file"
    Write-Host "2. Create users one by one"
    Write-Host "3. Show all users in the AD"
    Write-Host "4. Delete user one by one"
    Write-Host "5. Delete multiple users"
    Write-Host "6. Exit"
    Write-Host "==============================="
}

# Main script to display menu and call functions based on user input
do {
    Show-Menu
    $choice = Read-Host "Please select an option (1-6)"

    switch ($choice) {
        1 { Create-UsersFromCSV } # Call the function to create users from CSV
        2 { Create-UserManually } # Call the function to create users one by one
        3 { Show-AllADUsers }     # Call the function to show all AD users
        4 { Delete-UserOneByOne }    # Call the function to delete a single user
        5 { Delete-MultipleUsers }   # Call the function to delete multiple users
        6 { Write-Host "Exiting..."; break } # Exit the script
        default { Write-Host "Invalid option. Please select a valid option (1-6)." }
    }

    if ($choice -ne 6) {
        Read-Host "Press Enter to return to the menu"
    }
} while ($choice -ne 6)