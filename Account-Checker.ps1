while ($true) {
    #get user info and set discrete variables for output

    Write-Host 'Account to check?'

    $account = Read-Host
    $user = Get-ADUser $account -Properties *
    $username = $user.SamAccountName 
    $passwordLastSet = [datetime]$user.PasswordLastSet
    $passwordAge = (Get-Date) - $passwordLastSet
    $passwordExpirationDate = $passwordLastSet.AddDays(90)
    $userLocked = $user.LockedOut
    $passwordExpired = $user.PasswordExpired
    #write findings and confirm admin actions (ie check if you want to set different attributes based on findings)

    switch ($userLocked) {
        True {
            Write-Host -ForegroundColor Red -Object 'User is locked out. Unlocking user, confirm Y/N?'
            $continuePrompting = $true
            while ($continuePrompting) {
                $input3 = Read-Host
                switch ($input3) {
                    'y' {
                            Unlock-AdAccount $user -Confirm
                            Write-Host -ForegroundColor Green -Object 'Account has been unlocked.'
                            $continuePrompting = $false
                        }
                    'n' { 
                            Write-Host -ForegroundColor Yellow -object 'Confirmed. Account will remain locked.'
                            $continuePrompting = $false
                        }
                    default {'Invalid option. Enter y or n.'}
                }
            }
        }
        False {Write-Host -ForegroundColor Green -Object 'User is not locked out.'}
    }

    Write-Host "Password age for $username is $($passwordAge.Days) days. Password was last set $passwordLastSet Password expires $passwordExpirationDate."
    switch ($passwordExpired) {
        True {
            Write-Host -ForegroundColor Red "The password expired on $passwordExpirationDate. Setting password to never expire so user can log in, confirm?"
            $continuePrompting = $true
            while ($continuePrompting) {
                $input4 = Read-Host
                switch ($input4) {
                    'y' {
                            Set-ADUser $user -PasswordNeverExpires $true -Confirm
                            Write-Host -ForegroundColor Yellow -Object 'User password set to never expire. Check their account again when they change their password.'
                            $continuePrompting = $false
                        }
                    'n' { 
                            Write-Host -ForegroundColor Yellow -object 'Confirmed. Will not set password to never expire.'
                            $continuePrompting = $false
                        }
                    default {'Invalid option. Enter y or n.'}
                }
            }
            }
            False {
                Write-Host "Password not currently set as expired. Verifying password age and account settings..."
            }
    }
    #refetching user so that the info is updated and output is accurate
    $user = (Get-ADUser $Account -properties *)
    switch ($user.PasswordNeverExpires) {
        True { 
                Write-Host -ForegroundColor Yellow "Password set to never expire. Set password to expire?" 
                $continuePrompting = $true
                while ($continuePrompting) {
                    $input2 = Read-Host
                    switch ($input2) {
                        'y' {
                                Set-ADUser $user -PasswordNeverExpires $false -Confirm
                                Write-Host -ForegroundColor Green -Object "Account password is set to expire. Password expiration date is $passwordExpirationDate"
                                $continuePrompting = $false
                            }
                        'n' { 
                                Write-Host 'Confirmed. Account password will remain set to never expire.'
                                $continuePrompting = $false
                            }
                        default {'Invalid option. Enter y or n.'}
                    }
                }
            }

        False { Write-Host -ForegroundColor Green "Password set to expire. Password expiration date is $passwordExpirationDate"}
    }
} 
