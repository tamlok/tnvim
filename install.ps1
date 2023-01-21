# NeoVim's Setup Utils on Windows
# Le Tan (tamlokveer at gmail.com)
# https://github.com/tamlok/tnvim

# We use scoop to manage neovim binary.
function Setup-Neovim
{
    $filesFolder = $env:USERPROFILE + '\AppData\Local\nvim'
    robocopy ".\" "$filesFolder" /E /MT /XD .git /XF .git* > $null
}

Setup-Neovim
