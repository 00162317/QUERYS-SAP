SELECT T0."DocEntry", T0."U_CardCode", T0."U_Cliente",  T0."CreateDate", T0."CreateTime", T0."Status", T0."Remark" as "COMENTARIO" , 
T0."U_Puntos_Redimidos",  T0."U_Premio", T0."U_Tipo_Premio" 
FROM "@PUNTAJE_CLIENTE" T0
WHERE T0."U_Puntos_Redimidos" != 0