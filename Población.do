import delimited C:\Users\74389492V\Desktop\EHDN_poblacion.TXT, delimiter("|")

*Borrar duplicados 
duplicates drop

*Borrar CIPAs falsos
sort cipa
drop if cipa < 1000000000

*Generar F_Nacimiento (variable numérica)
generate F_Nacimiento = date(fec_nacimiento, "DMY")
format %tdDD/NN/CCYY F_Nacimiento
label variable F_Nacimiento "Fecha de nacimiento"

*Generar F_Baja (variable numérica)
generate F_Baja = date(fecha_baja, "DMY")
format %tdDD/NN/CCYY F_Baja
label variable F_Baja "Fecha de baja"

*Generar Sexo (variable binaria)
generate Sexo = .
replace Sexo = 0 if sexo == "M"
replace Sexo = 1 if sexo == "F"
label variable Sexo "Sexo variable binaria"
label define dSexo 0 "Hombre" 1 "Mujer"
label values Sexo dSexo

*Generar Nombre_centro_cat categorizada
encode nombre_centro, generate(Nombre_centro_cat)

*Generar Nombre_residencia_cat categorizada
encode nombre_residencia, generate(Nombre_residencia_cat)

*Generar Motivo_baja_cat categorizada
encode motivo_baja, generate(Motivo_baja_cat)

*Generar Municipio_cat categorizada
encode municipio, generate(Municipio_cat)

*Borrar variables
drop fec_nacimiento sexo nombre_centro-motivo_baja municipio

