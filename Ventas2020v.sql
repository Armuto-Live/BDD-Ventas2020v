CREATE TABLE IF NOT EXISTS `persona` (
  `ID_persona` INT(11) NOT NULL,
  `nombres` VARCHAR(30) NULL DEFAULT NULL,
  `apellidos` VARCHAR(30) NULL DEFAULT NULL,
  `DNI` VARCHAR(10) NULL DEFAULT '10771899',
  PRIMARY KEY (`ID_persona`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = LATIN1;

CREATE TABLE IF NOT EXISTS `cliente` (
  `ID_persona_c` INT(11) NOT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`ID_persona_c`),
  CONSTRAINT `cliente_ibfk_1`
    FOREIGN KEY (`ID_persona_c`)
    REFERENCES `persona` (`ID_persona`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = LATIN1;

select * from cliente;
select * from persona;


CREATE TABLE IF NOT EXISTS `producto` (
  `ID_producto` INT(11) NOT NULL,
  `nombre` VARCHAR(40) NULL DEFAULT NULL,
  `descripcion` VARCHAR(30) NULL DEFAULT NULL,
  `precio` DOUBLE NULL DEFAULT NULL,
  `stock` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_producto`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ventasxyz`.`vendedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vendedor` (
  `ID_persona_v` INT(11) NOT NULL,
  `sueldo` DECIMAL(8,2) NULL DEFAULT NULL,
  PRIMARY KEY (`ID_persona_v`),
  CONSTRAINT `vendedor_ibfk_1`
    FOREIGN KEY (`ID_persona_v`)
    REFERENCES `persona` (`ID_persona`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ventasxyz`.`factura`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `factura` (
  `ID_factura` VARCHAR(5) NOT NULL,
  `fecha_factura` DATE NULL DEFAULT NULL,
  `ID_persona_c` INT(11) NULL DEFAULT NULL,
  `ID_persona_v` INT(11) NULL DEFAULT NULL,
  `TOTALFACTURA` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`ID_factura`),
  INDEX `ID_persona_c` (`ID_persona_c` ASC),
  INDEX `ID_persona_v` (`ID_persona_v` ASC),
  CONSTRAINT `factura_ibfk_1`
    FOREIGN KEY (`ID_persona_c`)
    REFERENCES `cliente` (`ID_persona_c`),
  CONSTRAINT `factura_ibfk_2`
    FOREIGN KEY (`ID_persona_v`)
    REFERENCES `vendedor` (`ID_persona_v`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `ventasxyz`.`detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `detalle` (
  `ID_Detalle` INT(11) NOT NULL,
  `ID_producto` INT(11) NULL DEFAULT NULL,
  `ID_factura` VARCHAR(5) NULL DEFAULT NULL,
  `cantidad` DOUBLE NULL DEFAULT NULL,
  `SubTotal02` DOUBLE NULL DEFAULT NULL,
  PRIMARY KEY (`ID_Detalle`),
  INDEX `ID_producto` (`ID_producto` ASC),
  INDEX `ID_factura` (`ID_factura` ASC),
  CONSTRAINT `detalle_ibfk_1`
    FOREIGN KEY (`ID_producto`)
    REFERENCES `producto` (`ID_producto`),
  CONSTRAINT `detalle_ibfk_2`
    FOREIGN KEY (`ID_factura`)
    REFERENCES `factura` (`ID_factura`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


INSERT INTO persona VALUES (1,'Jose','Perez','20120410'),(2,'Rina','Torres','20111225'),(3,'Rosa','Salas','20120625'),(4,'Oliver','Gamarra','20110822'),(5,'Alicia','Romero','20111224'),(6,'Joaquin','Rojas','20111126'),(7,'Rebeca','Ricalde','20120404'),(8,'Roberto','Gozales','20000404'),(9,'Anastasia','Perez','12200404');

INSERT INTO cliente VALUES (1,DATE('2012-04-10')),(2,DATE('2012-04-10')),(3,DATE('2012-04-10')),(4,DATE('2012-04-10')),(5,DATE('2012-04-10')),(6,DATE('2012-04-10')),(7,DATE('2012-04-10'));

INSERT INTO vendedor VALUES (8,2800),(9,2900);

INSERT INTO producto VALUES (1,'FIERRO 3/4','BARRA',20,200),(2,'FIERRO 1/2','BARRA',12,200),(3,'LAVATORIO TREBOL CLASICO BLANCO','UNIDAD',200,200),(4,'CERROJO FORTE TRIPLE SEGURO','UNIDAD',54,200),(5,'CERROJO FORTE SIMPLE','UNIDAD',38.5,200),(6,'MAYOLICA CELIMA 20X50 BLANCA','METRO CUADRADO',20,200),(7,'MAOLICA CELIMA 35X20 COLOR','METRO CUADRADO',30,200),(8,'BAÑERA LOZA COLOR','UNIDAD',500,200),(9,'BAÑERA LOZA BLANCA','UNIDAD',300,200),(10,'BAÑERA LOZA BLANCA MARCA XYZ','UNIDAD',300,200);

INSERT INTO factura VALUES ('R001',DATE('2011-07-25'),1,8,0),('R002',DATE('2011-07-26'),1,8,0),('R003',DATE('2011-07-27'),2,8,0),('R004',DATE('2011-07-28'),3,8,0),('R005',DATE('2011-07-29'),4,8,0),('R006',DATE('2011-07-30'),5,9,0),('R007',DATE('2011-07-31'),1,9,0);

INSERT INTO detalle VALUES (2,2,'R001',10,0),(1,1,'R001',5,0),(3,3,'R002',1,0),(4,2,'R003',12,0),(5,3,'R003',1,0),(6,6,'R004',7,0),(7,5,'R005',1,0),(8,4,'R006',1,0),(9,3,'R007',1,0);



SELECT * FROM cliente;
SELECT * FROM persona;
SELECT * FROM vendedor;
SELECT * FROM factura;
SELECT * FROM producto;
SELECT * FROM detalle;

drop procedure ClientesMasVentas;

CALL ListarPersona();
CALL DATOS_CLIENTE();
CALL DATOS_VENDEDOR();
CALL CLIENTES_VENTAS();
use ventas2020v;
select * from persona;


delimiter //
create procedure ListarPersona()
begin
select * from persona;
end //
delimiter ;


delimiter //
create procedure ListarVendedor()
begin
select p.ID_persona,p.nombres,p.apellidos,p.DNI,v.sueldo
from vendedor v ,persona p 
where v.ID_persona_v=p.ID_persona;
end //
delimiter ;

delimiter //
create procedure ListarClientes()
begin 
select p.ID_persona as id_cliente,upper(CONCAT(p.nombres,' ',p.apellidos))as nombre,p.DNI,c.fecha_nacimiento
from persona p,cliente c
where p.ID_persona=c.ID_persona_c;
end //
delimiter ;

delimiter //
create procedure ProductosMasVentas()
begin
select d.ID_producto,p.nombre ,sum(d.cantidad) as cantidadTotalVentas 
from detalle d,producto p
where d.ID_producto=p.ID_producto 
group by ID_producto order by cantidadTotalVentas desc;
end //
delimiter ;

delimiter //
create procedure ClientesMasVentas()
begin
select pe.ID_persona,concat((pe.nombres),' ',UPPER(pe.apellidos)) as nombre,pe.DNI,count(pe.ID_persona)as totalVecesCompra
from cliente c, persona pe,factura fac
where c.ID_persona_c=pe.ID_persona and pe.ID_persona=fac.ID_persona_c 
group by fac.ID_persona_c;
end //
delimiter ;
drop procedure spBuscarCliente;


call spBuscarCliente('Jose',@nombres);
select @nombres;

delimiter //
create procedure BuscarVendedor(
nom varchar(30)
)
begin
select p.ID_persona,p.nombres,p.apellidos,p.DNI,v.sueldo
from vendedor v ,persona p 
where v.ID_persona_v=p.ID_persona and nombres like concat(nom,'%');
end //
delimiter ;
select * from persona;
call BuscarVendedor('jose'); 
 
 
 delimiter //
create procedure returnBuscarVendedor(
nom varchar(30),
out valor varchar(30)
)
begin
select concat(nombres,apellidos) into valor
from vendedor v ,persona p 
where v.ID_persona_v=p.ID_persona and nombres like concat(nom,'%');
end //
delimiter ;


delimiter //
create procedure busquedaProductos(
prec double,
nom varchar(30)
)
begin

select d.ID_producto,p.nombre ,p.precio 
from detalle d,producto p
where d.ID_producto=p.ID_producto and precio=prec and p.nombre like concat(nom,'%');

end //
delimiter ;
drop procedure busquedaProductos;
call busquedaProductos(20,'fierro');	
call productosMasVentas();

use ventas2020v;
delimiter //
create procedure returnbusquedaProductos(
prec double,
nom varchar(30),
out valor varchar(50)
)
begin
if exists(select concat('ID Producto: ',p.ID_producto,', ',nombre ,', precio: $',precio )
from detalle d,producto p
where d.ID_producto=p.ID_producto and p.precio=prec and p.nombre like concat(nom,'%')) then 
set valor=(
select concat('ID Producto: ',p.ID_producto,', ',nombre ,', precio: $',precio )
from detalle d,producto p
where d.ID_producto=p.ID_producto and p.precio=prec and p.nombre like concat(nom,'%'));
else
set valor=' producto no encontrado';
end if;
end //
delimiter ;


drop procedure returnbusquedaProductos;
call returnbusquedaProductos(10,'fierro',@Producto);
select@Producto;

delimiter //
Create procedure spRegistrarPersona
(
in pNombre varchar(20),
in pApellido varchar(20),
in pDNI varchar(9),
in pFechaNacimiento date,
in pSueldo decimal(8,2)
)
begin
declare varID, varAlterno int;
declare varia int;

select count(id_persona), id_persona into varia, varAlterno from persona
where nombres=pNombre and apellidos=pApellido and DNI=pDNI;
set varID=(select max(id_persona)+1 from persona);
IF(varia>0) then
if (pSueldo=0) then 
	insert into Cliente() values(varID,pFechaNacimiento);
    else 
    insert into vendedor() values(varID,pSueldo);
    end if;

insert into Persona() values(varID,pNombre,pApellido,pDNI);
if (pSueldo=0) then 
	insert into Cliente() values(varID,pFechaNacimiento);
    else 
    insert into vendedor() values(varID,pSueldo);
    end if;
end //
delimiter ;

select max(id_persona)+1 from persona;
call spRegistrarPersona('Yasuo', 'Soreketon','34', date('1845,03,19'),2000);
select * from cliente;
select * from persona;
delimiter //
CREATE PROCEDURE spRegistrarPersona(
IN pNombre varchar(80),
IN pAp varchar(80),
IN pDNI varchar(8),
IN pFN date,
IN pSueldo decimal(8,2)
)
BEGIN
Declare varID,varIDalterno int;
Declare varFlag int;
Select count(id_persona),id_persona INTO varFlag,varIDalterno From persona
Where nombres=pNombre AND apellidos=pAp AND DNI=pDNI;
-- Select max(id_persona)+1 INTO varID from persona;
Set varID=(Select max(id_persona)+1 from persona);
-- verficar si existe
IF (varFlag>0) THEN
	-- hacer solo a
    IF (pSueldo=0) THEN 
		Insert Into cliente() values(varIDalterno,pFN);
	ELSE
		Insert Into vendedor() values(varIDalterno,pSueldo);
	END IF;
ELSE
	-- hacer b y a
		Insert Into Persona() values(varID,pNombre,pAP,pDNI);
	IF (pSueldo=0) THEN 
		Insert Into cliente() values(varID,pFN);
	ELSE
		Insert Into vendedor() values(varID,pSueldo);
	END IF;
END IF;
END //
delimiter ;

call spRegistrarPersona('Ren','Alameda','48976123',date('2002-01-12'),3000);
select * from cliente;
select * from persona;
select * from vendedor;
delimiter //
CREATE PROCEDURE `spGestionaProducto`(
IN pID int,
IN pNomb varchar(80),
IN pDesc varchar(80),
IN pPrecio double,
IN pStock int
)
BEGIN
Declare varID int;
Set varID=(Select max(id_producto)+1 from producto);
IF (pID=0) THEN
	Insert Into producto() values(varID,pNomb,pDesc,pPrecio,pStock);
ELSEIF(pID!=0 && pNomb!='') THEN
	Update producto SET nombre=pNomb Where id_producto=pID;
ELSEIF(pID!=0 && pNomb='') THEN
	Delete from producto Where id_producto=pID;
END IF;
END //
delimiter ;

delimiter // 
CREATE PROCEDURE spNuevoIDFactura(
IN pIDCli int,
IN pIDVend int
)
BEGIN

Insert Into factura() values(fnNuevoIDFactura(),current_date(),pIDCli,pIDVend,0);

END //
delimiter ;

call spNuevoIDFactura(4,8);

select * from factura;

delimiter //
CREATE FUNCTION fnPrecioProducto (pID int, pNombre varchar(80))
returns double 
begin 
declare vPrecio double;

if (pID=0) then
	set vPrecio = (select precio from producto where nombre = pNombre);
else
	set vPrecio = (select precio from producto where ID_producto=pID);
end if;
return vPrecio;
end //
delimiter ;

select fnNombreProducto(4);
select * from producto;
select fnPrecioProducto(2,'fierro 3/4');

delimiter //
create function fnNuevoIDFactura()
RETURNS varchar(5) CHARSET latin1
BEGIN
Declare vIDFac varchar(5);
Declare vIDFacInt int;
Set vIDFacInt = (Select right(max(ID_factura),3)+1 from factura);
IF (vIDFacInt<=9) THEN
	Set vIDFac = concat('R00',vIDFacInt);
ELSEIF (vIDFacInt>9 && vIDFacInt<=99) THEN
	Set vIDFac = concat('R0',vIDFacInt);
ELSEIF (vIDFacInt>99 && vIDFacInt<=999) THEN
	Set vIDFac = concat('R',vIDFacInt);
END IF;

RETURN vIDFac;
END //
delimiter ;

call spNuevoIDFactura(15,7);


delimiter //
create procedure spGestionarFactura
(
in pFlag varchar(1),
in pIDFact varchar(5),
IN pIDCli int,
in pIDVend int
)
begin
case pFlag
	when 'a' then 
		insert into factura()
        values(fnNuevoIDFactura(),current_date(),pIDCli,pIDVend,0);
	when 'b' then
		update factura set id_personsa_c=pIDVend where id_factura=pIDFact;
	else
		delete from factura where id_factura=pIDFact;
	end case; 
end //
delimiter ;
call spGestionarFactura('a','',1,8);
select * from factura;

select * from detalle;
delimiter //
Create function fnPrecio(pIDpr int)
returns double
begin
declare vPrecio double;

set vPrecio = (select precio from producto where ID_producto=pIDpr);

return vPrecio;
end //
delimiter ;
select * from producto;
select fnPrecio(10);
select *,cantidad*fnPrecio(ID_producto) from detalle;

delimiter //
create procedure spActualizarDetalle()
begin
declare _error boolean default false;
declare vIDDet int;
declare vSubTotal double;
declare MatrizX cursor for
select ID_detalle,cantidad*fnPrecio(ID_producto) from detalle;
declare continue handler for sqlstate '02000' set _error = true;
open MatrizX;

repeat
	fetch MatrizX into vIDDet, vSubTotal ;
    update detalle set SubTotal02 = vSubTotal where ID_Detalle=vIDDet;
    
    until _error end repeat;

end //
delimiter ;

call spActualizarDetalle();
select * from detalle;
use ventas2020v;

select factura.ID_factura, factura.*,sum(SubTotal02) from factura, detalle
where factura.ID_factura=detalle.ID_factura group by factura.ID_factura;

select * from detalle;
select * from factura;

delimiter //
create procedure spActualizarFactura()
begin
declare _error boolean default false;
declare vIDF varchar(5);
declare vTotal double;

declare MatrizTotal cursor for
select factura.ID_factura,sum(SubTotal02) from factura, detalle
where factura.ID_factura=detalle.ID_factura group by factura.ID_factura;

declare continue handler for sqlstate '02000' set _error = true;
open MatrizTotal;

repeat
	fetch MatrizTotal into vIDF, vTotal ;
    
    update factura set TOTALFACTURA = vTotal,IGV=(vTotal*.19) where ID_factura=vIDF;
  
    until _error end repeat;

end //
delimiter ;
call spActualizarFactura();
alter table factura add column IGV double;
select * from factura;

delimiter //
create procedure spGestionarDetalle
(
pIDDet int,
pIDPr int,
pIDFac varchar(5),
pCant int
)
begin

declare varID int; 
set varID=(select max(id_detalle)+1 from detalle);


if(pIDDet=0) then
insert into detalle() values(varID,pIDPr,pIDFac,pCant,pCant*fnPrecio(pIDPr));
elseif(pIDDet!=0 && pIDPr!=0) then
update detalle set cantidad=pCant,ID_producto=pIDPr,SubTotal02=pCant*fnPrecio(pIDPr) where ID_Detalle=pIDDet;
elseif(pIDDet!=0 && pIDPr=0) then
delete from detalle where ID_Detalle=pIDDet;
end if;
end //
delimiter ;
select * from detalle;
select * from producto;
call spGestionarDetalle(10,0,'',4);
call spGestionarDetalle(11,0,'',0);
delete from detalle where ID_Detalle=10;