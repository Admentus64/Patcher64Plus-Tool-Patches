function ByteOptions() {

    # MISC #
    
    if (IsChecked $Redux.Gameplay.BlackBars)       { ChangeBytes -Offset @("262AA1F", "262AA21") -Values "00" }
    if (IsChecked $Redux.Gameplay.HPSound)         { ChangeBytes -Offset "2608E66" -Values "0000" }
    if (IsChecked $Redux.Gameplay.FastRang)        { ChangeBytes -Offset "2087E6D" -Values "0F"; ChangeBytes -Offset "A37329" -Values "41C0" }
    if (IsChecked $Redux.Gameplay.FastArrows)      { ChangeBytes -Offset @("B4013D", "B41CAE") -Values "10" }
    if (IsChecked $Redux.Gameplay.FastCharge)      { ChangeBytes -Offset "A63591" -Values "3E50" }
    if (IsChecked $Redux.Gameplay.FastRoll)        { ChangeBytes -Offset "209ABAD" -Values "4030" }
    if (IsChecked $Redux.Gameplay.FastZTargetMove) { ChangeBytes -Offset "209AC4D" -Values "A0"; ChangeBytes -Offset "209AC4F" -Values "672D3F" }

    # HERO MODE #

    if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage") { ChangeBytes -Offset "2088154" -Values "2BC3" }
    elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage") { ChangeBytes -Offset "2088154" -Values "2B83" }
    elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage") { ChangeBytes -Offset "2088154" -Values "2B43" }

    # MAGIC COSTS #

    if (IsDefault $Redux.Magic.FireArrow  -Not) { ChangeBytes -Offset "209A426" -Values (Get8Bit $Redux.Magic.FireArrow.Text) }
    if (IsDefault $Redux.Magic.IceArrow   -Not) { ChangeBytes -Offset "209A428" -Values (Get8Bit $Redux.Magic.IceArrow.Text) }
    if (IsDefault $Redux.Magic.Burst 	  -Not) { ChangeBytes -Offset "209A7E1" -Values (Get8Bit $Redux.Magic.Burst.Text) }    
    if (IsDefault $Redux.Magic.Barrier 	  -Not) { ChangeBytes -Offset "209A7E0" -Values (Get8Bit $Redux.Magic.Barrier.Text) }

    # EQUIPMENT #

    if (IsText -Elem $Redux.Equipment.Sword2 -Compare "Big")          { ChangeBytes -Offset "266F129" -Values "45"; ChangeBytes -Offset "266F106" -Values "A8" }
    elseif (IsText -Elem $Redux.Equipment.Sword2 -Compare "Very Big") { ChangeBytes -Offset "266F129" -Values "46"; ChangeBytes -Offset "266F106" -Values "0B" }
    if (IsText -Elem $Redux.Equipment.Sword3 -Compare "Big")          { ChangeBytes -Offset "266F12E" -Values "45D864" }
    elseif (IsText -Elem $Redux.Equipment.Sword3 -Compare "Very Big") { ChangeBytes -Offset "266F12E" -Values "461B78" }
    if (IsText -Elem $Redux.Equipment.Hammer -Compare "Big")          { ChangeBytes -Offset "266F0F7" -Values "45"; ChangeBytes -Offset "266F134" -Values "48" }
    elseif (IsText -Elem $Redux.Equipment.Hammer -Compare "Very Big") { ChangeBytes -Offset "266F0F7" -Values "46"; ChangeBytes -Offset "266F134" -Values "0B" }
    if (IsDefault $Redux.Equipment.BrokenSword3 -Not) 		          { ChangeBytes -Offset "269B98E" -Values (ConvertFloatToHex $Redux.Equipment.BrokenSword3.Value) }
    if (IsDefault $Redux.Equipment.Stick -Not) 			              { ChangeBytes -Offset "269B98A" -Values (ConvertFloatToHex $Redux.Equipment.Stick.Value) }
    if (IsDefault $Redux.Equipment.Hookshot -Not)                     { ChangeBytes -Offset "A6F76B"  -Values (Get8Bit $Redux.Equipment.Hookshot.Value) }
    if (IsDefault $Redux.Equipment.Longshot -Not)                     { ChangeBytes -Offset "A6F758"  -Values (Get8Bit $Redux.Equipment.Longshot.Value) }
}


#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel

    $note = "May possibly cause sequence breaking!"

    # MISC #

    CreateReduxGroup    -Tag  "Gameplay"        -Text "Misc"
    CreateReduxCheckBox -Name "BlackBars"       -Text "No Black Bars"    	       -Info "Removes the black bars shown on the top & bottom of the screen.`nThis hack removes all instances of black bars rather than Z-targeting alone." -Credits "Admentus & Anthrogi (ported)"
    CreateReduxCheckBox -Name "HPSound"      	-Text "No Low HP Sound"		       -Info "Remove the sound effect for the low HP beeping."                                                                                               -Credits "Randomizer & Anthrogi (ported)"
    CreateReduxCheckbox -Name "FastRang" 	    -Text "Quicker Boomerang"          -Info "Boomerang flys faster and returns quicker while the return timer is reduced to approximate the original distance."                             -Credits "Anthrogi"
    CreateReduxCheckBox -Name "FastArrows" 	    -Text "Less Magic Arrows Cooldown" -Info "The burst animation for Fire, Ice and Light Arrows are shorter which allows for shooting the next magic arrow a bit quicker."                  -Credits "Anthrogi" -Warning "Due to other combined functions in the bytes for this hack, has odd changes to rotation effects when held before shot in some areas."
    CreateReduxCheckBox -Name "FastCharge" 	    -Text "Faster Lv2 Magic Spin"      -Info "Allows you to perform the lv2 magic spin attack quicker during charge."                                                                        -Credits "Anthrogi"
    CreateReduxCheckbox -Name "FastRoll" 	    -Text "Increased Rolling Distance" -Info "You'll move further upon rolling."                                                                                                             -Credits "Anthrogi" -Warning $note
    CreateReduxCheckbox -Name "FastZTargetMove" -Text "Faster Lock-On Movement"    -Info "You'll move faster when targeting something."                                                                                                  -Credits "Anthrogi" -Warning $note

    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero"   -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage" -Text "Damage" -Default 1 -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage") -Info "Set the amount of damage you'll receive." -Credits "Admentus (original) & Anthrogi (ported)"

    # MAGIC COSTS #

    CreateReduxGroup   -Tag  "Magic"     -Text "Magic Costs"
    CreateReduxTextBox -Name "FireArrow" -Text "Fire Arrow"   -Value 4  -Min 2 -Max 96 -Info "Set the magic cost for using Fire Arrows.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."  -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "IceArrow"  -Text "Ice Arrow"    -Value 4  -Min 2 -Max 96 -Info "Set the magic cost for using Ice Arrows.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."   -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Burst"  	 -Text "Din's Fire"   -Value 12 -Min 2 -Max 96 -Info "Set the magic cost for using Din's Fire.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."   -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Barrier"   -Text "Nayru's Love" -Value 24 -Min 2 -Max 96 -Info "Set the magic cost for using Nayru's Love.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter." -Credits "Admentus (original) & Anthrogi (ported)"

    # EQUIPMENT #

    CreateReduxGroup   	-Tag  "Equipment"    -Text "Equipment Adjustments"
    CreateReduxComboBox -Name "Sword2"       -Text "Sword 2"        -Default 1 -Items ("Default", "Big", "Very Big")                  -Info "Select the length size of the custom Master Sword."                                                                                                -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "Sword3"       -Text "Sword 3"        -Default 1 -Items ("Default", "Big", "Very Big")                  -Info "Select the length size of the custom Giant's_Knife/Biggoron's_Sword."                                                                              -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "Hammer"       -Text "Hammer"         -Default 1 -Items ("Default", "Big", "Very Big")                  -Info "Select the length size of the custom Megaton Hammer."                                                                                              -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "BrokenSword3" -Text "Broken Sword 3" -Default 1500 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the custom Broken Giant's Knife."                                                                                         -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "Stick"        -Text "Stick"          -Default 5000 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the custom Deku Stick.`nNOTE: Also affects the tip that can be set aflame, use carefully if trying to set it as a torch!" -Credits "Anthrogi"
    CreateReduxSlider   -Name "Hookshot"     -Text "Hookshot"       -Default 13   -Min 10   -Max 110  -Freq 10  -Small 5   -Large 10  -Info "Set the length of the Hookshot.`nNOTE: Going above the default length by a certain amount can look weird."                                         -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "Longshot"     -Text "Longshot"       -Default 104  -Min 10   -Max 110  -Freq 10  -Small 5   -Large 10  -Info "Set the length of the Longshot.`nNOTE: Going above the default length by a certain amount can look weird."                                         -Credits "Admentus (original) & Anthrogi (ported)"
}