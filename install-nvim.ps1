Invoke-WebRequest -Uri "https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip" -OutFile "nvim-win64.zip"

# Extract here first
Expand-Archive -Path "nvim-win64.zip" -DestinationPath "nvim-win64" -Force

# Move the extracted files to the desired location
Move-Item -Path "nvim-win64\nvim-win64\*" -Destination "C:\Program Files\Neovim" -Force
Remove-Item -Path "nvim-win64" -Recurse -Force
Remove-Item -Path "nvim-win64.zip"
