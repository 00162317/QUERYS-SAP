SELECT SUBSTRING(T1."SeriesName",0,3) Tipo, T0."DocNum", T0."DocDate", T0."DocTime" FROM OINV T0
INNER JOIN NNM1 T1 ON T0."Series" = T1."Series" WHERE T0."DocDate" >=[%0] AND  T0."DocDate" <=[%1]