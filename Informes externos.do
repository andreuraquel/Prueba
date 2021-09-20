*Importar base de datos
import delimited C:\Users\74389492V\Desktop\EHDN_informes_externos.TXT, delimiter("|")


*Borrar duplicados
duplicates drop

*Borrar CIPAs falsos
drop if cipa < 1000000000

*Generar F_Ingreso (variable numérica)
generate F_Ingreso = date(fecha_ingreso, "DMY")
format %tdDD/NN/CCYY F_Ingreso
label variable F_Ingreso "Fecha de ingreso"

*Generar F_Alta(variable numérica)
generate F_Alta = date(fecha_alta , "DMY")
format %tdDD/NN/CCYY F_Alta
label variable F_Alta "Fecha de alta"

*Generar Tip_Inf (variable binaria)
generate Tip_Inf = .
replace Tip_Inf = 0 if tipo_informe == "H"
replace Tip_Inf = 1 if tipo_informe == "U"
label variable Tip_Inf "Tipo de informe binaria"
label define dTip_Inf 0 "Hospital" 1 "Urgencias"
label values Tip_Inf dTip_Inf

*Generar estancia
generate Estancia = F_Alta - F_Ingreso
label variable Estancia "Días de ingreso"

*Generar Servicio categorizada
encode servicio, generate(Servicio_Cat)
label variable Servicio_Cat "Servicio categorizada"


*Primera ola
keep if F_Ingreso >=date("28feb2020", "DMY") & F_Ingreso <=date("11may2020", "DMY")

*Segunda ola
keep if F_Ingreso >=date("10jul2020", "DMY") & F_Ingreso <=date("6dec2020", "DMY")


*Ordenar por CIPA, Fecha de ingreso y Fecha de alta
sort cipa F_Ingreso F_Alta

*Crear variable seguimiento
by cipa, sort: gen Seg = _n
label variable Seg "Identificador de seguimiento"

*Borrar variables
drop fecha_ingreso fecha_alta tipo_informe servicio hospital observaciones

*Reshape 2ª ola
reshape wide F_Ingreso F_Alta Tip_Inf Estancia Servicio_Cat, i(cipa) j(Seg)

*Eliminar a partir del 10 informe
drop F_Ingreso11 F_Alta11 Tip_Inf11 Estancia11 F_Ingreso12 F_Alta12 Tip_Inf12 Estancia12 F_Ingreso13 F_Alta13 Tip_Inf13 Estancia13 F_Ingreso14 F_Alta14 Tip_Inf14 Estancia14 F_Ingreso15 F_Alta15 Tip_Inf15 Estancia15 F_Ingreso16 F_Alta16 Tip_Inf16 Estancia16 F_Ingreso17 F_Alta17 Tip_Inf17 Estancia17 F_Ingreso18 F_Alta18 Tip_Inf18 Estancia18 F_Ingreso19 F_Alta19 Tip_Inf19 Estancia19 F_Ingreso20 F_Alta20 Tip_Inf20 Estancia20 F_Ingreso21 F_Alta21 Tip_Inf21 Estancia21 F_Ingreso22 F_Alta22 Tip_Inf22 Estancia22 F_Ingreso23 F_Alta23 Tip_Inf23 Estancia23 F_Ingreso24 F_Alta24 Tip_Inf24 Estancia24 F_Ingreso25 F_Alta25 Tip_Inf25 Estancia25 F_Ingreso26 F_Alta26 Tip_Inf26 Estancia26 F_Ingreso27 F_Alta27 Tip_Inf27 Estancia27 F_Ingreso28 F_Alta28 Tip_Inf28 Estancia28 F_Ingreso29 F_Alta29 Tip_Inf29 Estancia29 F_Ingreso30 F_Alta30 Tip_Inf30 Estancia30 F_Ingreso31 F_Alta31 Tip_Inf31 Estancia31 F_Ingreso32 F_Alta32 Tip_Inf32 Estancia32 F_Ingreso33 F_Alta33 Tip_Inf33 Estancia33 F_Ingreso34 F_Alta34 Tip_Inf34 Estancia34 F_Ingreso35 F_Alta35 Tip_Inf35 Estancia35 F_Ingreso36 F_Alta36 Tip_Inf36 Estancia36 F_Ingreso37 F_Alta37 Tip_Inf37 Estancia37 F_Ingreso38 F_Alta38 Tip_Inf38 Estancia38 F_Ingreso39 F_Alta39 Tip_Inf39 Estancia39 F_Ingreso40 F_Alta40 Tip_Inf40 Estancia40 F_Ingreso41 F_Alta41 Tip_Inf41 Estancia41 F_Ingreso42 F_Alta42 Tip_Inf42 Estancia42 F_Ingreso43 F_Alta43 Tip_Inf43 Estancia43 F_Ingreso44 F_Alta44 Tip_Inf44 Estancia44 F_Ingreso45 F_Alta45 Tip_Inf45 Estancia45 F_Ingreso46 F_Alta46 Tip_Inf46 Estancia46 F_Ingreso47 F_Alta47 Tip_Inf47 Estancia47 F_Ingreso48 F_Alta48 Tip_Inf48 Estancia48 F_Ingreso49 F_Alta49 Tip_Inf49 Estancia49 F_Ingreso50 F_Alta50 Tip_Inf50 Estancia50 F_Ingreso51 F_Alta51 Tip_Inf51 Estancia51 F_Ingreso52 F_Alta52 Tip_Inf52 Estancia52 F_Ingreso53 F_Alta53 Tip_Inf53 Estancia53 F_Ingreso54 F_Alta54 Tip_Inf54 Estancia54 F_Ingreso55 F_Alta55 Tip_Inf55 Estancia55 F_Ingreso56 F_Alta56 Tip_Inf56 Estancia56 F_Ingreso57 F_Alta57 Tip_Inf57 Estancia57 F_Ingreso58 F_Alta58 Tip_Inf58 Estancia58 F_Ingreso59 F_Alta59 Tip_Inf59 Estancia59 F_Ingreso60 F_Alta60 Tip_Inf60 Estancia60

*Generar nº de ingresos
egen float Num_Ingresos = rownonmiss(F_Ing*)
label variable Num_Ingresos "Nº total de ingresos"

*Generar días totales de ingreso
egen float Dias_Totales = rowtotal(Estancia*)
label variable Dias_Totales "Días totales de ingreso"

*Generar Inf_Urg_Total e Inf_Hosp_Total
egen float Inf_Urg_Total = rowtotal(Tip_Inf*)
label variable Inf_Urg_Total "Nº total de informes de urgencia"
egen byte Inf_Hosp_Total = anycount(Tip_Inf*), values(0)
label variable Inf_Hosp_Total "Nº total de informes hospitalarios"


*Reshape 1ª ola
reshape wide F_Ingreso F_Alta Tip_Inf Estancia Servicio_Cat, i(cipa) j(Seg)

*Eliminar a partir del 10 informe 
drop F_Ingreso11 F_Alta11 Tip_Inf11 Estancia11 F_Ingreso12 F_Alta12 Tip_Inf12 Estancia12 F_Ingreso13 F_Alta13 Tip_Inf13 Estancia13 F_Ingreso14 F_Alta14 Tip_Inf14 Estancia14 F_Ingreso15 F_Alta15 Tip_Inf15 Estancia15 F_Ingreso16 F_Alta16 Tip_Inf16 Estancia16 F_Ingreso17 F_Alta17 Tip_Inf17 Estancia17 F_Ingreso18 F_Alta18 Tip_Inf18 Estancia18 F_Ingreso19 F_Alta19 Tip_Inf19 Estancia19 F_Ingreso20 F_Alta20 Tip_Inf20 Estancia20 F_Ingreso21 F_Alta21 Tip_Inf21 Estancia21 F_Ingreso22 F_Alta22 Tip_Inf22 Estancia22 F_Ingreso23 F_Alta23 Tip_Inf23 Estancia23 F_Ingreso24 F_Alta24 Tip_Inf24 Estancia24 F_Ingreso25 F_Alta25 Tip_Inf25 Estancia25 F_Ingreso26 F_Alta26 Tip_Inf26 Estancia26 F_Ingreso27 F_Alta27 Tip_Inf27 Estancia27 F_Ingreso28 F_Alta28 Tip_Inf28 Estancia28 F_Ingreso29 F_Alta29 Tip_Inf29 Estancia29 F_Ingreso30 F_Alta30 Tip_Inf30 Estancia30 

*Generar nº de ingresos
egen float Num_Ingresos = rownonmiss(F_Ing*)
label variable Num_Ingresos "Nº total de ingresos"

*Generar días totales de ingreso
egen float Dias_Totales = rowtotal(Estancia*)
label variable Dias_Totales "Días totales de ingreso"

*Generar Inf_Urg_Total e Inf_Hosp_Total
egen float Inf_Urg_Total = rowtotal(Tip_Inf*)
label variable Inf_Urg_Total "Nº total de informes de urgencia"
egen byte Inf_Hosp_Total = anycount(Tip_Inf*), values(0)
label variable Inf_Hosp_Total "Nº total de informes hospitalarios"


