*Importar BD
import delimited C:\Users\74389492V\Desktop\EHDN_visitas.TXT, delimiter("|") clear 


*Borrar duplicados 
duplicates drop

*Borrar CIPAs falsos
sort cipa
drop if cipa < 1000000000

*Generar Especialidad categorizada
encode especialidad, generate(Especialidad_Cat)

*Generar F_Visita (variable numérica)
generate F_Visita = date(fecha_visita, "DMY")
format %tdDD/NN/CCYY F_Visita
label variable F_Visita "Fecha de visita"

*Generar variable Fecha_Hora cadena
generate str Fecha_Hora = fecha_visita +" " + hora_visita
label variable Fecha_Hora "Fecha y hora (cadena)"

*Generar variable Fecha_Hora numérica
gen double Fecha_Hora_Num = clock(Fecha_Hora, "DMYhms")
format Fecha_Hora_Num %tc 
label variable Fecha_Hora_Num "Fecha y hora (variable numérica)"

*Borrar variables
drop fecha_visita-especialidad
drop Fecha_Hora

*Segunda ola
keep if F_Visita >=date("10jul2020", "DMY") & F_Visita <=date("6dec2020", "DMY")

*Primera ola
keep if F_Visita >=date("28feb2020", "DMY") & F_Visita <=date("11may2020", "DMY")


*Ordenar por CIPA y Fecha de visita 
sort cipa F_Visita

*Crear variable seguimiento
by cipa, sort: gen Seg = _n
label variable Seg "Identificador de seguimiento"

*Reshape 2ª ola
reshape wide F_Visita Especialidad_Cat Fecha_Hora_Num, i(cipa) j(Seg)

*Generar nº de visitas
egen float Num_Visitas = rownonmiss(F_Vis*)
label variable Num_Visitas "Nº total de visitas"

tab Num_Visitas

*Borrar a partir de más de 30 visitas
drop F_Visita30-Fecha_Hora_Num206

*Generar nº de visitas reducido
egen float Num_Visitas_Red = rownonmiss(F_Vis*)
label variable Num_Visitas_Red "Nº de visitas reducido (<30)"


*Reshape 1ª ola
reshape wide F_Visita Especialidad_Cat Fecha_Hora_Num, i(cipa) j(Seg)

*Generar nº de visitas
egen float Num_Visitas = rownonmiss(F_Vis*)
label variable Num_Visitas "Nº total de visitas"

tab Num_Visitas

*Borrar a partir de más de 30 visitas
drop Especialidad_Cat30-Fecha_Hora_Num112

*Generar nº de visitas reducido
egen float Num_Visitas_Red = rownonmiss(F_Vis*)
label variable Num_Visitas_Red "Nº de visitas reducido (<30)"
