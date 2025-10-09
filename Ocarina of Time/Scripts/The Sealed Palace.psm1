function ByteOptions() {

    # MISC #
    
    if (IsChecked $Redux.Gameplay.NoKillFlash)       { ChangeBytes -Offset "B35573" -Values "00" }
    if (IsChecked $Redux.Gameplay.InstantClaimCheck) { ChangeBytes -Offset "1EB327C" -Values "00000000"; ChangeBytes -Offset "1EB32A4" -Values "00000000" }
    if (IsChecked $Redux.Gameplay.BlackBars)         { ChangeBytes -Offset "B2ABEC" -Values "00000000" }
    if (IsChecked $Redux.Gameplay.TextSpeed)         { ChangeBytes -Offset "B80AAB" -Values "02" }
    if (IsChecked $Redux.Gameplay.FastRang) 		 { ChangeBytes -Offset "1B7CE8B" -Values "10"; ChangeBytes -Offset "1C0F5E2" -Values "41C0" }
    if (IsChecked $Redux.Gameplay.FastBullets)       { ChangeBytes -Offset @("1BD2E82", "1BD2EBE") -Values "4330"; ChangeBytes -Offset @("1DBF502", "1DC14C2", "1DC34A2") -Values "0010" }
    if (IsChecked $Redux.Gameplay.FastCharge) 		 { ChangeBytes -Offset @("1C51C58", "1C51C64") -Values "3E12159A"; ChangeBytes -Offset "1C51C6C" -Values "3DC448CD"; ChangeBytes -Offset @("1C51C60", "1C51C70", "1C51C9C") -Values "3E132200" }
    if (IsChecked $Redux.Gameplay.FastRoll) 	     { ChangeBytes -Offset "1B9BFD0" -Values "4030" }
    if (IsChecked $Redux.Gameplay.FastZTargetMove)   { ChangeBytes -Offset "1B9C018" -Values "3FA0672D" }

    # SOUNDS / VOICES #

    if (IsDefault -Elem $Redux.Sounds.ChildVoices -Not) {
        $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1FB000" -Patch $file }
    }

    if (IsDefault -Elem $Redux.Sounds.AdultVoices -Not) {
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1A95E0" -Patch $file }
    }

    # HERO MODE #

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) {
        if (IsIndex -Elem $Redux.Hero.MonsterHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }

        MultiplyBytes -Offset @("1D349DF", "1BE1167") -Factor $multi -Max 127 # Like-Like, Peehat, 
        MultiplyBytes -Offset @("1D038CB", "1D4D03B") -Factor $multi -Max 127 # Shell Blade, Spike Ball
        MultiplyBytes -Offset @("1C141AC", "1C5EFFC") -Factor $multi -Max 127 # Biri, Bari
        MultiplyBytes -Offset @("1C8E667", "1BBC7C4") -Factor $multi -Max 127 # ReDead/Gibdo, Regular/Composer Poe
        MultiplyBytes -Offset @("1C19353", "1C0611B") -Factor $multi -Max 127 # Torch Slug, Gohma Larva
        MultiplyBytes -Offset @("1C66327", "1C677FB") -Factor $multi -Max 127 # Blue Bubble, Red Bubble
        MultiplyBytes -Offset   "1C14777"             -Factor $multi -Max 127 # Tailpasaran
        MultiplyBytes -Offset   "1C1E0AC"             -Factor $multi -Max 127 # Stinger
        MultiplyBytes -Offset @("1BDC69B", "1BDC70F") -Factor $multi -Max 127 # Red Tektite, Blue Tektite
        MultiplyBytes -Offset @("1BC337C", "1C8CB8C") -Factor $multi -Max 127 # Wallmaster, Floormaster
        MultiplyBytes -Offset @("1BDF4E7", "1BDF57B") -Factor $multi -Max 127 # Leever, Purple Leever
        MultiplyBytes -Offset @("1C7D103", "1C7D107") -Factor $multi -Max 127 # Big & Regular Beamos
        MultiplyBytes -Offset   "1BC3C1F"             -Factor $multi -Max 127 # Dodongo
        MultiplyBytes -Offset   "1C9DC64"             -Factor $multi -Max 127 # Regular/Gold Walltula
        MultiplyBytes -Offset   "1C18D8C"             -Factor $multi -Max 127 # Skulltula
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) {
        if (IsIndex -Elem $Redux.Hero.MiniBossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        MultiplyBytes -Offset @("1BA74E3", "1CC26FB", "1C9566C") -Factor $multi -Max 127 # Stalfos, Dead Hand, Poe Sisters
        MultiplyBytes -Offset @("1BEBE2F", "1BEBE3B")            -Factor $multi -Max 127 # Lizalfos, Dinolfos
        MultiplyBytes -Offset   "1EB7083"                        -Factor $multi -Max 127 # Wolfos
        MultiplyBytes -Offset   "1E9A14F"                        -Factor $multi -Max 127 # Gerudo Fighter
        MultiplyBytes -Offset   "1CAABE7"                        -Factor $multi -Max 127 # Flare Dancer

        if ($multi -eq 255 -and !$multiply) { ChangeBytes -Offset "1DC9677" -Values "FF"; ChangeBytes -Offset "1DCAC07" -Values "7F"; ChangeBytes -Offset "1DCABDB" -Values "7F" }
        elseif ($multi -gt 0) {
            MultiplyBytes -Offset "1DC9677" -Factor $multi                                             
            $value = $ByteArrayGame[(GetDecimal "1DCAC07")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "1DCAC07" -Values $value; ChangeBytes -Offset "1DCABDB" -Values $value 
        }
        else { ChangeBytes -Offset "1DC9677" -Values "01"; ChangeBytes -Offset "1DCAC07" -Values "01"; ChangeBytes -Offset "1DCABDB" -Values "01" } # Iron Knuckle
    }
    
    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) {
        if (IsIndex -Elem $Redux.Hero.BossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        MultiplyBytes -Offset   "1BF9057"             -Factor $multi -Max 127 # Gohma
        MultiplyBytes -Offset @("1CE1163", "1CE13AF") -Factor $multi -Max 127 # Barinade
        MultiplyBytes -Offset @("1D24A23", "1D21D93") -Factor $multi -Max 127 # Twinrova
        MultiplyBytes -Offset   "1BF4F5B"             -Factor $multi -Max 127 # King Dodongo
        MultiplyBytes -Offset   "1C9E957"             -Factor $multi -Max 127 # Volvagia
        MultiplyBytes -Offset   "1CF7F8F"             -Factor $multi -Max 127 # Morpha
        MultiplyBytes -Offset   "1D4BBA4"             -Factor $multi -Max 127 # Bongo Bongo
        MultiplyBytes -Offset   "1C454B3"             -Factor $multi -Min 4 -Max 127 # Phantom Ganon
        MultiplyBytes -Offset   "1E6A57B"             -Factor $multi -Min 3 -Max 127 # Ganon
    }
    
    if     (IsText -Elem $Redux.Hero.Damage     -Compare "2x Damage")      { ChangeBytes -Offset "1B7DFEA" -Values "2BC3" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "4x Damage")      { ChangeBytes -Offset "1B7DFEA" -Values "2B83" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "8x Damage")      { ChangeBytes -Offset "1B7DFEA" -Values "2B43" }
    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage") { ChangeBytes -Offset "AFE8C6"  -Values "2C40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage") { ChangeBytes -Offset "AFE8C6"  -Values "2C80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage") { ChangeBytes -Offset "AFE8C6"  -Values "2CC0" }

    if (IsChecked $Redux.Hero.NoBottledFairy) { ChangeBytes -Offset "1B9A7F4" -Values "00000000" }
     
    # HARDER ENEMIES #

    if (IsChecked $Redux.Enemy.Octorok)     { ChangeBytes -Offset "1BBCF82" -Values "4190"; ChangeBytes -Offset "1BBD2E6" -Values "0002"; ChangeBytes -Offset @("1BBD662", "1BBD96A") -Values "4450"; ChangeBytes -Offset "1BBD9E6" -Values "4500" }
    if (IsChecked $Redux.Enemy.HandMaster)  { ChangeBytes -Offset @("1BC1CE2", "1BC2436") -Values "0010"; ChangeBytes -Offset "1C8A212" -Values "4100"; ChangeBytes -Offset @("1C8A292", "1C8A2B2", "1C8B606", "1C8B672") -Values "0000"; ChangeBytes -Offset "1C8B8EA" -Values "4320"; ChangeBytes -Offset "1C8B9EE" -Values "4130"; ChangeBytes -Offset "1C8BD3E" -Values "000A" }
    if (IsChecked $Redux.Enemy.Keese)       { ChangeBytes -Offset "1BC6403" -Values "00"; ChangeBytes -Offset @("1BC6676", "1BC667E", "1BC67EE") -Values "0000"; ChangeBytes -Offset "1BC67DE" -Values "2000"; ChangeBytes -Offset "1BC688A" -Values "0070"; ChangeBytes -Offset "1BC6FB2" -Values "4428"; ChangeBytes -Offset @("1BC7186", "1BC719A") -Values "40F0"; ChangeBytes -Offset @("1BC747E", "1BC7486") -Values "40B8" }
    if (IsChecked $Redux.Enemy.Tektite)     { ChangeBytes -Offset @("1BDC7EA", "1BDC7EE") -Values "0000"; ChangeBytes -Offset "1BDCA86" -Values "40F0"; ChangeBytes -Offset @("1BDCAB6", "1BDD3EE", "1BDD876") -Values "4150"; ChangeBytes -Offset "364683D" -Values "05" }
    if (IsChecked $Redux.Enemy.Peahat)      { ChangeBytes -Offset @("1BE120E", "1BE1216") -Values "4500"; ChangeBytes -Offset "1BE17AA" -Values "4000"; ChangeBytes -Offset @("1BE1804", "1BE19E4", "1BE1B44", "1BE2260", "1BE2D7C", "1BE2FF4") -Values "00"; ChangeBytes -Offset "1BE22AA" -Values "0500"; ChangeBytes -Offset "1BE22BA" -Values "FB00"; ChangeBytes -Offset @("1BE21EA", "1BE21F2") -Values "4080"; ChangeBytes -Offset "1BE2282" -Values "0700" }
    if (IsChecked $Redux.Enemy.GohmaLarva)  { ChangeBytes -Offset @("1C06A66", "1C06EC2") -Values "0000"; ChangeBytes -Offset "1C07016" -Values "0006"; ChangeBytes -Offset "1C07202" -Values "40E0"; ChangeBytes -Offset "1C07286" -Values "4170"; ChangeBytes -Offset "1C073CA" -Values "4100"; ChangeBytes -Offset "1C07442" -Values "4323" }
    if (IsChecked $Redux.Enemy.Zombies)     { ChangeBytes -Offset @("1C8EA76", "1C8EA96", "1C8EAA2", "1C8EED2", "1C8EF22") -Values "4393"; ChangeBytes -Offset "1C8EE76" -Values "0376"; ChangeBytes -Offset @("1C8EF76", "1C8FAA2") -Values "000B"; ChangeBytes -Offset @("1C8F6D3", "1C8F8CF") -Values "0A"; ChangeBytes -Offset "1C90B6C" -Values "3FECECED" }
    if (IsChecked $Redux.Enemy.LikeLike)    { ChangeBytes -Offset "1D34D9A" -Values "0014"; ChangeBytes -Offset @("1D35B4A", "1D35C0A") -Values "1000"; ChangeBytes -Offset "1D35B7A" -Values "4500"; ChangeBytes -Offset "1D35BCA" -Values "4100" }
    if (IsChecked $Redux.Enemy.DekuScrub)   { ChangeBytes -Offset @("1C5B1DA", "1E99276") -Values "0000"; ChangeBytes -Offset "1C5B1E7" -Values "01"; ChangeBytes -Offset "1E99283" -Values "00"; ChangeBytes -Offset @("1C5B86E", "1C5B932", "1E99682", "1E9971E") -Values "1800"; ChangeBytes -Offset "1E988D2" -Values "4190"; ChangeBytes -Offset "37E41C5" -Values "0D"; ChangeBytes -Offset "3EA31ED" -Values "07" }
    if (IsChecked $Redux.Enemy.Guay)        { ChangeBytes -Offset "1ECCE66" -Values "0070"; ChangeBytes -Offset "1ECCE86" -Values "40F0"; ChangeBytes -Offset "1ECD3AA" -Values "40B8"; ChangeBytes -Offset "1ECD6F6" -Values "447B" }
    if (IsChecked $Redux.Enemy.Stalfos)     { ChangeBytes -Offset "1BA7A90" -Values "00000000"; ChangeBytes -Offset "1BAAF6A" -Values "D000"; ChangeBytes -Offset "3764979" -Values "07"; ChangeBytes -Offset "376E4E5" -Values "02"; ChangeBytes -Offset "376EE4D" -Values "11" }
    if (IsChecked $Redux.Enemy.Reptiles)    { ChangeBytes -Offset "1BEC6C8" -Values "00"; ChangeBytes -Offset @("1BEE3FA", "1BEE41E") -Values "4000"; ChangeBytes -Offset "1BEE72E" -Values "D000" }
    if (IsChecked $Redux.Enemy.DarkLink)    { ChangeBytes -Offset "1C0FD9F" -Values "FF" }
    if (IsChecked $Redux.Enemy.DeadHand)    { ChangeBytes -Offset @("1CC2CA2", "1CC2E16") -Values "4080"; ChangeBytes -Offset "1CC2CAE" -Values "0025"; ChangeBytes -Offset "1CC2E22" -Values "0011"; ChangeBytes -Offset "1CC2D0A" -Values "1200"; ChangeBytes -Offset "3A4EA3D" -Values "0B"; ChangeBytes -Offset "3A51659" -Values "01" }
    if (IsChecked $Redux.Enemy.IronKnuckle) { ChangeBytes -Offset "1DCC98C" -Values "40707070"; ChangeBytes -Offset "1DCC990" -Values "40C0"; ChangeBytes -Offset @("1DCA48E", "1DCA47A") -Values "0800"; ChangeBytes -Offset "1DCA64E" -Values "0001"; ChangeBytes -Offset @("1DC9D4E", "1DCA0C2") -Values "1500"; ChangeBytes -Offset "1DC9FE2" -Values "0320"; ChangeBytes -Offset "3C93539" -Values "03"; ChangeBytes -Offset @("3C939FD", "3C94DBD") -Values "02" }
    if (IsChecked $Redux.Enemy.Gerudo)      { ChangeBytes -Offset @("1E9B4D2", "1E9C5BE", "1E9C9AE") -Values "0000"; ChangeBytes -Offset "1E9C7C6" -Values "4200" }
    if (IsChecked $Redux.Enemy.Wolfos)      { ChangeBytes -Offset "1EB88CE" -Values "0000"; ChangeBytes -Offset "1EB8C8E" -Values "D000"; ChangeBytes -Offset "1EBADFF" -Values "00" }
    if (IsChecked $Redux.Enemy.Gohma)       { ChangeBytes -Offset "1BF96CA" -Values "0016"; ChangeBytes -Offset "1BFC3E6" -Values "0030"; ChangeBytes -Offset "1BFD46E" -Values "0020"; ChangeBytes -Offset "1BFD48E" -Values "000C" } 
    if (IsChecked $Redux.Enemy.KingDodongo) { ChangeBytes -Offset "1BF258A" -Values "4500"; ChangeBytes -Offset "1C0E7E2" -Values "427B"; ChangeBytes -Offset "1C0E7FE" -Values "0030"; ChangeBytes -Offset "1C0F214" -Values "41272727"; ChangeBytes -Offset "1BF59EE" -Values "0024"; ChangeBytes -Offset "1BF2C4A" -Values "0000" }

    # RECOVERY #

    if (IsDefault $Redux.Recovery.Heart       -Not) { ChangeBytes -Offset "AFD14E"  -Values (Get16Bit $Redux.Recovery.Heart.Text) }
    if (IsDefault $Redux.Recovery.Fairy       -Not) { ChangeBytes -Offset "1BD5ACA" -Values (Get16Bit $Redux.Recovery.Fairy.Text) }
    if (IsDefault $Redux.Recovery.FairyBottle -Not) { ChangeBytes -Offset "1B85466" -Values (Get16Bit $Redux.Recovery.FairyBottle.Text) }
    if (IsDefault $Redux.Recovery.FairyRevive -Not) { ChangeBytes -Offset "1B8F31E" -Values (Get16Bit $Redux.Recovery.FairyRevive.Text) }
    if (IsDefault $Redux.Recovery.Milk        -Not) { ChangeBytes -Offset "1B8502A" -Values (Get16Bit $Redux.Recovery.Milk.Text) }
    if (IsDefault $Redux.Recovery.RedPotion   -Not) { ChangeBytes -Offset "1B84FFE" -Values (Get16Bit $Redux.Recovery.RedPotion.Text) }
    if (IsDefault $Redux.Recovery.MagicJar1   -Not) { ChangeBytes -Offset "AFD182"  -Values (Get16Bit $Redux.Recovery.MagicJar1.Text) }
    if (IsDefault $Redux.Recovery.MagicJar2   -Not) { ChangeBytes -Offset "AFD1DA"  -Values (Get16Bit $Redux.Recovery.MagicJar2.Text) }

    # MAGIC COSTS #

    if (IsDefault $Redux.Magic.FireArrow  -Not) { ChangeBytes -Offset "1B9B864" -Values (Get8Bit $Redux.Magic.FireArrow.Text) }
    if (IsDefault $Redux.Magic.IceArrow   -Not) { ChangeBytes -Offset "1B9B865" -Values (Get8Bit $Redux.Magic.IceArrow.Text) }
    if (IsDefault $Redux.Magic.LightArrow -Not) { ChangeBytes -Offset "1B9B866" -Values (Get8Bit $Redux.Magic.LightArrow.Text) }
    if (IsDefault $Redux.Magic.Burst 	  -Not) { ChangeBytes -Offset "1B9B875" -Values (Get8Bit $Redux.Magic.Burst.Text) }    
    if (IsDefault $Redux.Magic.Teleport   -Not) { ChangeBytes -Offset "1B9B873" -Values (Get8Bit $Redux.Magic.Teleport.Text) }
    if (IsDefault $Redux.Magic.Barrier 	  -Not) { ChangeBytes -Offset "1B9B874" -Values (Get8Bit $Redux.Magic.Barrier.Text) }

    # EQUIPMENT COLORS #

    if ($Redux.Colors.SetEquipment -ne $null) {
        if (IsColor $Redux.Colors.SetEquipment[0] -Not) { ChangeBytes -Offset "B9D1A8" -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B) } # Kokiri Tunic
        if (IsColor $Redux.Colors.SetEquipment[1] -Not) { ChangeBytes -Offset "B9D1AB" -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B) } # Goron Tunic
        if (IsColor $Redux.Colors.SetEquipment[2] -Not) { ChangeBytes -Offset "B9D1AE" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) } # Zora Tunic
        if (IsColor $Redux.Colors.SetEquipment[3] -Not) { ChangeBytes -Offset "B9D1B4" -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
        if (IsColor $Redux.Colors.SetEquipment[4] -Not) { ChangeBytes -Offset "B9D1B7" -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
    }

    # MAGIC SPIN EFFECTS #

    if ($Redux.Colors.SetSpinAttack -ne $null) {
        if (IsColor $Redux.Colors.SetSpinAttack[0] -Not) { ChangeBytes -Offset "1F02614" -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[1] -Not) { ChangeBytes -Offset "1F02734" -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[2] -Not) { ChangeBytes -Offset "1F02B94" -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[3] -Not) { ChangeBytes -Offset "1F02CB4" -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }

    # TRAIL EFFECTS #

    if ($Redux.Colors.SetAttackTrail -ne $null) {
        if (IsColor   $Redux.Colors.SetAttackTrail[0] -Not)                  { ChangeBytes -Offset @("1B9A97C", "1B9A984") -Values @($Redux.Colors.SetAttackTrail[0].Color.R, $Redux.Colors.SetAttackTrail[0].Color.G, $Redux.Colors.SetAttackTrail[0].Color.B) }
        if (IsColor   $Redux.Colors.SetAttackTrail[1] -Not)                  { ChangeBytes -Offset @("1B9A980", "1B9A988") -Values @($Redux.Colors.SetAttackTrail[1].Color.R, $Redux.Colors.SetAttackTrail[1].Color.G, $Redux.Colors.SetAttackTrail[1].Color.B) }
        if (IsDefault $Redux.Colors.Duration1 -Not)                          { ChangeBytes -Offset "1B9A98C" -Values ($Redux.Colors.Duration1.SelectedIndex * 4) }
        if (IsText -Elem $Redux.Colors.Duration2 -Compare "Disabled")        { ChangeBytes -Offset "1C0F36B" -Values "00" }
        elseif (IsText -Elem $Redux.Colors.Duration2 -Compare "Longer")      { ChangeBytes -Offset "1C0F36B" -Values "0B" }
        elseif (IsText -Elem $Redux.Colors.Duration2 -Compare "Longest")     { ChangeBytes -Offset "1C0F36B" -Values "10" }
	    if (IsText -Elem $Redux.Colors.Alpha -Compare "Low Tip & Full Base") { ChangeBytes -Offset "1B9A97F" -Values "40"; ChangeBytes -Offset "1B9A983" -Values "FF" }
	    elseif (IsText -Elem $Redux.Colors.Alpha -Compare "Full Tip & Base") { ChangeBytes -Offset "1B9A97F" -Values "FF"; ChangeBytes -Offset "1B9A983" -Values "FF" }
    }

    # AMMO #

    if (IsDefault $Redux.Replenish.DekuStick    -Not) { ChangeBytes -Offset "AFC91F" -Values (Get8Bit $Redux.Replenish.DekuStick.Text) }
    if (IsDefault $Redux.Replenish.DekuNut_Bomb -Not) { ChangeBytes -Offset "B9CC29" -Values (Get8Bit $Redux.Replenish.DekuNut_Bomb.Text) }
    if (IsDefault $Redux.Replenish.DekuSeed     -Not) { ChangeBytes -Offset "AFCEEB" -Values (Get8Bit $Redux.Replenish.DekuSeed.Text) }
    if (IsDefault $Redux.Replenish.Arrows1      -Not) { ChangeBytes -Offset "B9CC31" -Values (Get8Bit $Redux.Replenish.Arrows1.Text) }
    if (IsDefault $Redux.Replenish.Arrows2      -Not) { ChangeBytes -Offset "B9CC33" -Values (Get8Bit $Redux.Replenish.Arrows2.Text) }
    if (IsDefault $Redux.Replenish.Arrows3      -Not) { ChangeBytes -Offset "B9CC35" -Values (Get8Bit $Redux.Replenish.Arrows3.Text) }

    # MONEY #

    if (IsDefault $Redux.Currency.Rupee1 -Not) { ChangeBytes -Offset "B9CC3C"  -Values (Get16Bit $Redux.Currency.Rupee1.Text) }
    if (IsDefault $Redux.Currency.Rupee2 -Not) { ChangeBytes -Offset "B9CC3E"  -Values (Get16Bit $Redux.Currency.Rupee2.Text) }
    if (IsDefault $Redux.Currency.Rupee3 -Not) { ChangeBytes -Offset "B9CC40"  -Values (Get16Bit $Redux.Currency.Rupee3.Text) }
    if (IsDefault $Redux.Currency.Rupee4 -Not) { ChangeBytes -Offset "B9CC42"  -Values (Get16Bit $Redux.Currency.Rupee4.Text) }
    if (IsDefault $Redux.Currency.Rupee5 -Not) { ChangeBytes -Offset "B9CC44"  -Values (Get16Bit $Redux.Currency.Rupee5.Text) }
    if (IsDefault $Redux.Currency.Rupee6 -Not) { ChangeBytes -Offset "1DD31CA" -Values (Get16Bit $Redux.Currency.Rupee6.Text) }

    # EQUIPMENT #

    if (IsDefault $Redux.Equipment.SwordHealth -Not) {
        $value = (Get8Bit $Redux.Equipment.SwordHealth.Text)
        ChangeBytes -Offset "AFC1AB" -Values $value
    }

    if (IsDefault $Redux.Equipment.Sword1       -Not)                 { ChangeBytes -Offset "B9D288"  -Values (ConvertFloatToHex $Redux.Equipment.Sword1.Value) }
    if (IsDefault $Redux.Equipment.Sword2       -Not)                 { ChangeBytes -Offset "B9D284"  -Values (ConvertFloatToHex $Redux.Equipment.Sword2.Value) }
    if (IsDefault $Redux.Equipment.Sword3    	-Not)                 { ChangeBytes -Offset "B9D28C"  -Values (ConvertFloatToHex $Redux.Equipment.Sword3.Value) }
    if (IsDefault $Redux.Equipment.BrokenSword3 -Not)                 { ChangeBytes -Offset "BB5AEC"  -Values (ConvertFloatToHex $Redux.Equipment.BrokenSword3.Value) }
    if (IsDefault $Redux.Equipment.Stick        -Not)                 { ChangeBytes -Offset "BB5AE0"  -Values (ConvertFloatToHex $Redux.Equipment.Stick.Value) }
    if (IsDefault $Redux.Equipment.Hammer       -Not)                 { ChangeBytes -Offset "B9D294"  -Values (ConvertFloatToHex $Redux.Equipment.Hammer.Value) }
    if (IsDefault $Redux.Equipment.Hookshot     -Not)                 { ChangeBytes -Offset "1C61773" -Values (Get8Bit $Redux.Equipment.Hookshot.Value) }
    if (IsDefault $Redux.Equipment.Longshot     -Not)                 { ChangeBytes -Offset "1C6175F" -Values (Get8Bit $Redux.Equipment.Longshot.Value) }
    if (IsText -Elem $Redux.Equipment.ShieldRecoil -Compare "None")   { ChangeBytes -Offset "1B9BF04" -Values "2000" }
    if (IsText -Elem $Redux.Equipment.ShieldRecoil -Compare "Little") { ChangeBytes -Offset "1B9BF04" -Values "C120" }
    if (IsText -Elem $Redux.Equipment.ShieldRecoil -Compare "Big")    { ChangeBytes -Offset "1B9BF04" -Values "C1B0" }
    if (IsText -Elem $Redux.Equipment.ShieldRecoil -Compare "Huge")   { ChangeBytes -Offset "1B9BF04" -Values "C200" }
}


#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel -Tabs @("Main", "Difficulty", "Colors", "Quantity", "Equipment")
    ChangeModelsSelection
}


#==============================================================================================================================================================================================
function CreateTabMain() {

    # MISC #
    
    $note1 = "May possibly cause sequence breaking!"

    CreateReduxGroup    -Tag  "Gameplay"          -Text "Misc" 
    CreateReduxCheckBox -Name "NoKillFlash"       -Text "No Kill Flash"               -Info "Disable the flashing effect when killing certain enemies like walltula etc."                                                                                                           -Credits "Chez Cousteau & Anthrogi (ported))"
    CreateReduxCheckBox -Name "InstantClaimCheck" -Text "Instant Claim Check"         -Info "Allows you to use the claim check immediately to get the biggoron's sword."                                                                                                            -Credits "Randomizer & Anthrogi (ported)"
    CreateReduxCheckBox -Name "BlackBars"         -Text "No Black Bars (Z-Targeting)" -Info "Removes the black bars shown on the top & bottom of the screen during Z-targeting."                                                                                                    -Credits "Admentus & Anthrogi (ported)"
    CreateReduxCheckBox -Name "TextSpeed"         -Text "2x Text Speed"               -Info "Makes text go 2x as fast."                                                                                                                                                             -Credits "Admentus & Anthrogi (ported)"
    CreateReduxCheckbox -Name "FastRang" 	      -Text "Quicker Boomerang" 	      -Info "Boomerang flys faster and returns quicker while the return timer is reduced to approximate the original distance."                                                                     -Credits "Anthrogi"
    CreateReduxCheckBox -Name "FastBullets"       -Text "Better Projectile Shots"     -Info "Deku Seeds and Arrows travel faster when shot, along with the burst animation for Fire, Ice and Light Arrows being shorter.`nAllows Link to shoot the next magic arrow a bit quicker." -Credits "Anthrogi"
    CreateReduxCheckBox -Name "FastCharge" 	      -Text "Faster Lv2 Magic Spin"       -Info "Allows you to perform the lv2 magic spin attack quicker during charge."                                                                                                                -Credits "Anthrogi"
    CreateReduxCheckbox -Name "FastRoll" 	      -Text "Increased Rolling Distance"  -Info "You'll move further upon rolling."                                                                                                                                                     -Credits "Anthrogi" -Warning $note1
    CreateReduxCheckbox -Name "FastZTargetMove"   -Text "Faster Lock-On Movement"     -Info "You'll move faster when targeting something."                                                                                                                                          -Credits "Anthrogi" -Warning $note1
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds"      -Text "Sounds/Voices"
    CreateReduxComboBox -Name "ChildVoices" -Text "Child Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child") -Info "Replace the voice used for the Young Player Model." -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Saeed & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    CreateReduxComboBox -Name "AdultVoices" -Text "Adult Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult") -Info "Replace the voice used for the Adult Player Model." -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Saeed & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
}


#==============================================================================================================================================================================================
function CreateTabDifficulty() {

    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")

    CreateReduxGroup    -Tag  "Hero"           -Text "Hero Mode"
    CreateReduxComboBox -Name "MonsterHP"      -Text "Monster HP"   -Default 3 -Items $items1                                                                   -Info "Set the amount of health for monsters.`nDoesn't include monsters which die in one hit."  -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "MiniBossHP"     -Text "Mini-Boss HP" -Default 3 -Items $items2                                                                   -Info "Set the amount of health for mini-bosses.`nSome enemies are not included due to issues." -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "BossHP"         -Text "Boss HP"      -Default 3 -Items $items3                                                                   -Info "Set the amount of health for bosses.`nSome have a max health cap."                       -Credits "Admentus, Marcelo20XX (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "Damage"         -Text "Damage"       -Default 1 -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage")                     -Info "Set the amount of damage you'll receive."                                                -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "MagicUsage"     -Text "Magic Usage"  -Default 1 -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the multiplier rate the magic is consumed at."                                       -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxCheckBox -Name "NoBottledFairy" -Text "No Bottled Fairies"                                                                                       -Info "Fairies can no longer be bottled, you'll have to buy them to store them."                -Credits "Admentus (original) & Anthrogi (ported)"

    # HARDER ENEMIES #

    CreateReduxGroup    -Tag  "Enemy"       -Text "Harder Enemies"
    CreateReduxCheckBox -Name "Octorok"     -Text "Octorok"           -Info "Octoroks appear from much further away and shoot projectiles much more faster at quicker intervals."                                                                                                         -Credits "Anthrogi"
    CreateReduxCheckBox -Name "HandMaster"  -Text "Handmaster"        -Info "Wallmasters drop from above much quicker.`nFloormasters attack faster and suffers less lag on miss or impact against player.`nFragmasters jump and start chasing from further away and drain health faster." -Credits "Anthrogi"
    CreateReduxCheckBox -Name "Keese"       -Text "Keese"             -Info "Keese attack faster and move further, as well as variations not losing their effect when impacting the player.`nThey also won't falter from hitting the player either."                                      -Credits "Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "Tektite"     -Text "Tektite"           -Info "Tektites chase the player more effectively and lunge with greater reach."                                                                                                                                    -Credits "Anthrogi"
    CreateReduxCheckBox -Name "Peahat"      -Text "Peahat"            -Info "Peahats will attack even at night and move much faster, along with rotating their blades a bit quicker."                                                                                                     -Credits "Anthrogi"
    CreateReduxCheckBox -Name "GohmaLarva"  -Text "Gohma Larva"       -Info "Gohma Larvas are faster and reach further."                                                                                                                                                                  -Credits "Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "Zombies"     -Text "Redead/Gibdo"      -Info "Redeads/Gibdos chase the player more quickly and efficiently, while also draining health faster."                                                                                                            -Credits "Anthrogi"
    CreateReduxCheckBox -Name "LikeLike"    -Text "Like-Like"         -Info "Like-Likes move faster and notice the player from much further away."                                                                                                                                        -Credits "Anthrogi"
    CreateReduxCheckBox -Name "DekuScrub"   -Text "Scrub"             -Info "2 out of 3 enemy Scrub variations will shoot their projectiles faster."                                                                                                                                      -Credits "Anthrogi"
    CreateReduxCheckBox -Name "Guay"        -Text "Guay"              -Info "Guays attack faster and move further."                                                                                                                                                                       -Credits "Anthrogi"
    CreateReduxCheckBox -Name "Stalfos"     -Text "Stalfos"           -Info "Stalfos do not falter from having attacks blocked and attack more efficiently.`nThey also attack when z-targeting another enemy."                                                                            -Credits "Nokaubure, BilonFullHDemon, Admentus & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "Reptiles"    -Text "Lizalfos/Dinolfos" -Info "Lizalfos/Dinolfos will attack faster and do not falter from having attacks blocked.`nThey also attack when z-targeting another enemy."                                                                       -Credits "Nokaubure, Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "DarkLink"    -Text "Dark Link"         -Info "Dark Link starts attacking you right away after spawning."                                                                                                                                                   -Credits "Nokaubure, BilonFullHDemon & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "DeadHand"    -Text "Dead Hand"         -Info "Dead Hands attack and move faster along with not staying risen for long."                                                                                                                                    -Credits "Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "IronKnuckle" -Text "Iron Knuckle"      -Info "Iron Knuckles are set to their phase 2 state and move faster along with attacking more efficiently."                                                                                                         -Credits "Admentus & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "Gerudo"      -Text "Gerudo Fighter"    -Info "Gerudo Fighters don't get distracted if player moves out of their sight and recovers from spin attacks instantly."                                                                                           -Credits "Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "Wolfos"      -Text "Wolfos"            -Info "Wolfos will attack faster and do not falter from having attacks blocked.`nThey also attack when z-targeting another enemy."                                                                                  -Credits "Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "Gohma"       -Text "Gohma"             -Info "Gohma recovers faster from being stunned."                                                                                                                                                                   -Credits "Euler & Anthrogi (also ported)"
    CreateReduxCheckBox -Name "KingDodongo" -Text "King Dodongo"      -Info "King Dodongo inhales faster and recovers from stun immediately along with shooting fireballs faster and for longer with increased size."                                                                     -Credits "Admentus, Euler & Anthrogi (also ported)"

    # RECOVERY #

    CreateReduxGroup   -Tag  "Recovery"    -Text "Recovery" -Height 4
    CreateReduxTextBox -Name "Heart"       -Text "Heart"             -Value 16  -Min 1 -Max 320 -Length 3 -Info "Set the amount of health that Hearts will restore."                             -Credits "Admentus, Three Pendants (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Fairy"       -Text "Fairy"             -Value 128 -Min 1 -Max 320 -Length 3 -Info "Set the amount of health that a Fairy will restore."                            -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "FairyBottle" -Text "Fairy (Bottle)"    -Value 320 -Min 1 -Max 320 -Length 3 -Info "Set the amount of health that a Bottled Fairy will restore."                    -Credits "Admentus, Three Pendants & Anthrogi (ported)"
    CreateReduxTextBox -Name "FairyRevive" -Text "Fairy (Revive)"    -Value 320 -Min 1 -Max 320 -Length 3 -Info "Set the amount of health that a Bottled Fairy will restore after Link is KO'd." -Credits "Admentus, Three Pendants & Anthrogi (ported)"; $Last.Row++
    CreateReduxTextBox -Name "Milk"        -Text "Milk"              -Value 80  -Min 1 -Max 320 -Length 3 -Info "Set the amount of health that the Milk will restore."                           -Credits "Admentus, Three Pendants & Anthrogi (ported)"
    CreateReduxTextBox -Name "RedPotion"   -Text "Red Potion"        -Value 320 -Min 1 -Max 320 -Length 3 -Info "Set the amount of health that a Red Potion will restore."                       -Credits "Admentus, Three Pendants (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "MagicJar1"   -Text "Magic Jar (Small)" -Value 12  -Min 2 -Max 96  -Length 2 -Info "Set the amount of magic that Small Magic Jars will restore."                    -Credits "Anthrogi"
    CreateReduxTextBox -Name "MagicJar2"   -Text "Magic Jar (Big)"   -Value 24  -Min 2 -Max 96  -Length 2 -Info "Set the amount of magic that Big Magic Jars will restore."                      -Credits "Anthrogi"

    $Redux.Recovery.HeartLabel       = CreateLabel -X $Redux.Recovery.Heart.Left       -Y ($Redux.Recovery.Heart.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Heart.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyLabel       = CreateLabel -X $Redux.Recovery.Fairy.Left       -Y ($Redux.Recovery.Fairy.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Fairy.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyBottleLabel = CreateLabel -X $Redux.Recovery.FairyBottle.Left -Y ($Redux.Recovery.FairyBottle.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyBottle.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyReviveLabel = CreateLabel -X $Redux.Recovery.FairyRevive.Left -Y ($Redux.Recovery.FairyRevive.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyRevive.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.MilkLabel        = CreateLabel -X $Redux.Recovery.Milk.Left        -Y ($Redux.Recovery.Milk.Bottom        + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Milk.text/16,        1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.RedPotionLabel   = CreateLabel -X $Redux.Recovery.RedPotion.Left   -Y ($Redux.Recovery.RedPotion.Bottom   + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.RedPotion.text/16,   1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.Heart.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.HeartLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.HeartLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Fairy.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.FairyLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.FairyLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyBottle.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyBottleLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyBottleLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyRevive.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyReviveLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyReviveLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Milk.Add_TextChanged(        { if ($this.text -eq "16") { $Redux.Recovery.MilkLabel.Text        = "(1 Heart)" } else { $Redux.Recovery.MilkLabel.Text        = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.RedPotion.Add_TextChanged(   { if ($this.text -eq "16") { $Redux.Recovery.RedPotionLabel.Text   = "(1 Heart)" } else { $Redux.Recovery.RedPotionLabel.Text   = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )

    # MAGIC COSTS #

    CreateReduxGroup   -Tag  "Magic"      -Text "Magic Costs"
    CreateReduxTextBox -Name "FireArrow"  -Text "Fire Arrow"    -Value 4  -Min 2 -Max 96 -Info "Set the magic cost for using Fire Arrows.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."   -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "IceArrow"   -Text "Ice Arrow"     -Value 4  -Min 2 -Max 96 -Info "Set the magic cost for using Ice Arrows.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."    -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "LightArrow" -Text "Light Arrow"   -Value 8  -Min 2 -Max 96 -Info "Set the magic cost for using Light Arrows.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."  -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Burst"  	  -Text "Din's Fire"    -Value 12 -Min 2 -Max 96 -Info "Set the magic cost for using Din's Fire.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."    -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Teleport"   -Text "Farore's Wind" -Value 12 -Min 2 -Max 96 -Info "Set the magic cost for using Farore's Wind.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter." -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Barrier"    -Text "Nayru's Love"  -Value 24 -Min 2 -Max 96 -Info "Set the magic cost for using Nayru's Love.`n48 is the maximum amount of the standard magic meter while 96 is the maximum amount of the double magic meter."  -Credits "Admentus (original) & Anthrogi (ported)"
}


#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @(); $Buttons = @(); $Redux.Colors.SetEquipment = @()
    $items1 = @("Kokiri Green", "Goron Red", "Zora Blue"); $postItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    $Items2 = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Items3 = @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic"     -Text "Kokiri Tunic"     -Default 1 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic.`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Kokiri Tunic" -Info "Select the color you want for the Kokiri Tunic." -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"      -Text "Goron Tunic"      -Default 2 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic.`n"  + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Goron Tunic"  -Info "Select the color you want for the Goron Tunic."  -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"       -Text "Zora Tunic"       -Default 3 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic.`n"  + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Zora Tunic"   -Info "Select the color you want for the Zora Tunic."   -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets" -Text "Silver Gauntlets" -Default 1 -Length 230 -Items $Items2 -Info ("Select a color scheme for the Silver Gauntlets.`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Silver Gaunlets"  -Info "Select the color you want for the Silver Gauntlets." -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets" -Text "Golden Gauntlets" -Default 2 -Length 230 -Items $Items2 -Info ("Select a color scheme for the Golden Gauntlets.`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Golden Gauntlets" -Info "Select the color you want for the Golden Gauntlets." -Credits "Randomizer"
    
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"  -IsGame -Button $Buttons[1]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"   -IsGame -Button $Buttons[2]
    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame -Button $Buttons[3]
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame -Button $Buttons[4]
    }

    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        if ($Buttons[$i] -eq $null) { break }
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color.Name })
        if ($i -lt 3)   { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetEquipment[$i].Color }
        else            { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetEquipment[$i].Color }
    }

    $Redux.Colors.Equipment[0].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0]
    $Redux.Colors.Equipment[1].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1]
    $Redux.Colors.Equipment[2].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2]

    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.Equipment[3].Add_SelectedIndexChanged({ SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3] })
        SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3]
        $Redux.Colors.Equipment[4].Add_SelectedIndexChanged({ SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4] })
        SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4]
    }

    # COLORS #

    CreateSpinAttackColorOptions
    CreateAttackTrailColorOptions
}


#==============================================================================================================================================================================================
function CreateTabQuantity() {

    # AMMO #

    CreateReduxGroup   -Tag  "Replenish"    -Text "Ammo"
    CreateReduxTextBox -Name "DekuStick"    -Text "Deku Sticks"     -Value 1   -Min 1 -Max 30  -Info "Set the amount gained for picking up a Deku Stick."       -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "DekuNut_Bomb" -Text "Deku_Nuts/Bombs" -Value 5   -Min 1 -Max 40  -Info "Set the amount gained for picking up Deku Nuts or Bombs." -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "DekuSeed"     -Text "Deku Seeds"      -Value 5   -Min 1 -Max 50  -Info "Set the amount gained for picking up Deku Seed Bullets."  -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Arrows1"      -Text "Arrow Type 1"    -Value 5   -Min 1 -Max 50  -Info "Set the amount gained for picking up Single Arrows."      -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Arrows2"      -Text "Arrow Type 2"    -Value 10  -Min 1 -Max 50  -Info "Set the amount gained for picking up Double Arrows."      -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Arrows3"      -Text "Arrow Type 3"    -Value 30  -Min 1 -Max 50  -Info "Set the amount gained for picking up Triple Arrows."      -Credits "Admentus (original) & Anthrogi (ported)"
    
    # MONEY #

    CreateReduxGroup   -Tag  "Currency"         -Text "Money"
    CreateReduxTextBox -Name "Rupee1" -Length 3 -Text "Rupee (Green)"       -Value 1   -Min 1 -Max 500 -Info "Set the amount gained for picking up Green Rupees."          -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Rupee2" -Length 3 -Text "Rupee (Blue)"        -Value 3   -Min 1 -Max 500 -Info "Set the amount gained for picking up Blue Rupees."           -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Rupee3" -Length 3 -Text "Rupee (Red)"         -Value 15  -Min 1 -Max 500 -Info "Set the amount gained for picking up Red Rupees."            -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Rupee4" -Length 3 -Text "Rupee (Purple)"      -Value 50  -Min 1 -Max 500 -Info "Set the amount gained for picking up Purple Rupees."         -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Rupee5" -Length 3 -Text "Rupee (Orange/Gold)" -Value 200 -Min 1 -Max 500 -Info "Set the amount gained for picking up Orange or Gold Rupees." -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxTextBox -Name "Rupee6" -Length 3 -Text "Rupee (Silver)"      -Value 5   -Min 1 -Max 500 -Info "Set the amount gained for picking up Silver Rupees."         -Credits "Admentus (original) & Anthrogi (ported)"
}


#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # EQUIPMENT #

    $note2 = "Going above the default length by a certain amount can look weird."

    CreateReduxGroup    -Tag  "Equipment"    -Text "Equipment Adjustments"
    CreateReduxTextBox  -Name "SwordHealth"  -Text "Sword Durability" -Length 3 -Value 8 -Min 1 -Max 255                                -Info "Set the amount of hits the Giant's Knife can take before it breaks."                                                                        -Credits "Admentus (original) & Anthrogi (ported)" 
    CreateReduxComboBox -Name "ShieldRecoil" -Text "Shield Recoil"    -Default 3 -Items @("None", "Little", "Normal", "Big", "Huge")    -Info "Choose the pushback rate when getting hit while shielding."                                                                                 -Credits "Admentus (ROM & original), Aegiker (RAM & original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "Sword1"       -Text "Sword 1"          -Default 3000 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the Kokiri Sword."                                                                                                 -Credits "Admentus (original) & Anthrogi (ported)" 
    CreateReduxSlider   -Name "Sword2"       -Text "Sword 2"          -Default 4000 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the Master Sword."                                                                                                 -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "Sword3"       -Text "Sword 3"          -Default 5500 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the Giant's_Knife/Biggoron_Sword."                                                                                 -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "BrokenSword3" -Text "Broken Sword 3"   -Default 1500 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the Broken Giant's Knife."                                                                                         -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "Stick"        -Text "Stick"            -Default 5000 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the Deku Stick.`nNOTE: Also affects the tip that can be set aflame, use carefully if trying to set it as a torch!" -Credits "Anthrogi"
    CreateReduxSlider   -Name "Hammer"       -Text "Hammer"           -Default 2500 -Min 1024 -Max 9216 -Freq 512 -Small 256 -Large 512 -Info "Set the hitbox length of the Megaton Hammer."                                                                                               -Credits "Admentus (original) & Anthrogi (ported)"
    CreateReduxSlider   -Name "Hookshot"     -Text "Hookshot"         -Default 13   -Min 10   -Max 110  -Freq 10  -Small 5   -Large 10  -Info "Set the length of the Hookshot."                                                                                                            -Credits "Admentus (original) & Anthrogi (ported)" -Warning $note2
    CreateReduxSlider   -Name "Longshot"     -Text "Longshot"         -Default 104  -Min 10   -Max 110  -Freq 10  -Small 5   -Large 10  -Info "Set the length of the Longshot."                                                                                                            -Credits "Admentus (original) & Anthrogi (ported)" -Warning $note2
}


#==============================================================================================================================================================================================
function CreateAttackTrailColorOptions() {
    
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons   = $Redux.Colors.SetAttackTrail = $Redux.Colors.AttackTrailLabels = @()

    CreateReduxGroup    -Tag  "Colors"                -Text "Trail Effects"
    CreateReduxComboBox -Name "AttackTrail"           -Text "Attack Color"       -Default 1 -Items @("White", "Black", "Red", "Green", "Blue", "Cyan", "Magenta", "Gray", "Randomized", "Custom") -Info ("Select a preset for the attack trail color.")                      -Credits "Rando Team (original) & Anthrogi (ported)"
    $buttons += CreateReduxButton -Tag $Buttons.Count -Text "Trail (Tip)"                                                                                                                         -Info "Select the tip color you want for the attack trail."                -Credits "Rando Team (original) & Anthrogi (ported)"
    $buttons += CreateReduxButton -Tag $Buttons.Count -Text "Trail (Base)"                                                                                                                        -Info "Select the base color you want for the attack trail."               -Credits "Rando Team (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "Duration1"             -Text "Attack Duration"    -Default 2 -Items @("Disabled", "Default", "Long", "Longer", "Lightsaber")                                       -Info "Select the attack trail duration."                                  -Credits "Rando Team (original) & Anthrogi (ported)"
    CreateReduxComboBox -Name "Duration2"             -Text "Bommerang Duration" -Default 2 -Items @("Disabled", "Default", "Longer", "Longest")                                                  -Info "Select the boomerang trail duration."                               -Credits "Anthrogi"
    CreateReduxComboBox -Name "Alpha"                 -Text "Attack Alpha Style" -Default 1 -Items @("Default", "Low Tip & Full Base", "Full Tip & Base")                                         -Info "Select the attack trail transparent style you want when attacking." -Credits "Anthrogi"

    $Redux.Colors.SetAttackTrail += CreateColorDialog -Color "FFFFFF" -Name "SetTipTrail"  -IsGame -Button $Buttons[0]
    $Redux.Colors.SetAttackTrail += CreateColorDialog -Color "FFFFFF" -Name "SetBaseTrail" -IsGame -Button $Buttons[1]

    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({
            $Redux.Colors.SetAttackTrail[[int16]$this.Tag].ShowDialog(); $Redux.Colors.AttackTrailLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetAttackTrail[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetAttackTrail[[int16]$this.Tag].Tag] = $Redux.Colors.SetAttackTrail[[int16]$this.Tag].Color.Name
            $Redux.Colors.AttackTrail.Text = "Custom"
        })
        $Redux.Colors.AttackTrailLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetAttackTrail[$i].Color
    }

    if (IsSet $Redux.Colors.AttackTrail) {
	$Redux.Colors.AttackTrail.Add_SelectedIndexChanged({ 
	SetAttackColorsPreset -ComboBox $Redux.Colors.AttackTrail -Dialog $Redux.Colors.SetAttackTrail[0] -Label $Redux.Colors.AttackTrailLabels[0] 
	SetAttackColorsPreset -ComboBox $Redux.Colors.AttackTrail -Dialog $Redux.Colors.SetAttackTrail[1] -Label $Redux.Colors.AttackTrailLabels[1]
	})
  }
}
function SetAttackColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Black")        { SetColor -Color "000000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gray")         { SetColor -Color "808080" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "White")        { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Red")          { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blue")         { SetColor -Color "0000FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Cyan")         { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Magenta")      { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Color." }
}
function SetRandomColor([object]$Dialog, [object]$Label, [string]$Message) {

    $green = Get8Bit -Value (Get-Random -Maximum 255)
    $red   = Get8Bit -Value (Get-Random -Maximum 255)
    $blue  = Get8Bit -Value (Get-Random -Maximum 255)
    if (IsSet $Message) { WriteToConsole ($Message + ": " + ($green + $red + $blue)) }
    SetColor -Color ($green + $red + $blue) -Dialog $Dialog -Label $Label
    return ($green + $red + $blue)
}