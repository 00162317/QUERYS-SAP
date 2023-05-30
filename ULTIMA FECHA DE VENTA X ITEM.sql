SELECT T0."ItemCode", MAX(T0."DocDate") AS "Ultima Fecha de Venta"
FROM INV1 T0
GROUP BY T0."ItemCode"