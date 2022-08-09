ado files: "C:\Users\NVatsa\ado\plus\e"
Local work saved to: "\\Client\C$\Users\nvatsa\EDP"
GitHub repository: "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\"


# 1. from GitHib repo to ado
Copy-Item "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\educationdata\educationdata.ado"   -Destination "C:\Users\NVatsa\ado\plus\e\"
Copy-Item "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\educationdata\educationdata.sthlp" -Destination "C:\Users\NVatsa\ado\plus\e\"


# 2. from ado to local
Copy-Item "C:\Users\NVatsa\ado\plus\e\educationdata.ado"   -Destination "\\Client\C$\Users\nvatsa\EDP\"
Copy-Item "C:\Users\NVatsa\ado\plus\e\educationdata.sthlp" -Destination "\\Client\C$\Users\nvatsa\EDP\"

# 3. from local to ado (to test code)
Copy-Item "\\Client\C$\Users\nvatsa\EDP\educationdata.ado"   -Destination "C:\Users\NVatsa\ado\plus\e"
Copy-Item "\\Client\C$\Users\nvatsa\EDP\educationdata.sthlp" -Destination "C:\Users\NVatsa\ado\plus\e"

# 4. from ado to GitHub (to push)
Copy-Item "C:\Users\NVatsa\ado\plus\e\educationdata.ado"   -Destination "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\educationdata\"
Copy-Item "C:\Users\NVatsa\ado\plus\e\educationdata.sthlp" -Destination ""C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\educationdata\"

# 5. copy from educationdata to docs (within GitHub)
Copy-Item "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\educationdata\educationdata.ado" "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\docs\educationdata.ado" 
Copy-Item "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\educationdata\educationdata.sthlp" -Destination "C:\Users\NVatsa\Desktop\EDP\education-data-package-stata\docs\educationdata.sthlp" 