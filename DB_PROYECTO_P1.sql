/*---creaión de la base de datos
create tablespace dtf_db_proyecto_p1 datafile 'C:\tablespace\dtf_db_proyecto_p1' size 25M;
create user DB_PROYECTO_P1 identified by nlopez default tablespace dtf_db_proyecto_p1 temporary tablespace temp account unlock;
grant connect, resource to DB_PROYECTO_P1;
*/

/* --para eliminar todas las tablas y secuencias , volver a ejecutar todas las tablas y las secuencias

delete from material;
delete from catalogo_material;
delete from solicitud_mantenimiento;
delete from cliente;
delete from tecnico;
delete from material;
delete from solicitud_mantenimiento;
delete from SOLICITUD_MANTENIMIENTO;
drop table CATALOGO_MATERIAL;
drop table SOLICITUD_MANTENIMIENTO;
drop table TECNICO;
drop table especialidad_tecnico;
drop table material;
drop table cliente;
drop table tipo_mantenimiento;
drop table pago;
drop table status_solicitud;

--drop sequence sec_cliente;
--drop sequence sec_tecnico;
--drop sequence sec_solicitud
--drop sequence sec_material;
--drop sequence sec_material;
--drop sequence sec_catalogoMaterial;
*/

create sequence sec_cliente start with 1 increment by 1;
create sequence sec_tecnico start with 1 increment by 1;
create sequence sec_solicitud start with 1 increment by 1;
create sequence sec_catalogoMaterial start with 1 increment by 1;
create sequence sec_material start with 1 increment by 1;




create table ESPECIALIDAD_TECNICO(
    idEspecialidad number primary key not null,
    especialidad varchar2(75)
);

create table TECNICO(
    idTecnico number primary key not null,
    nombre varchar2(50),
    direccion varchar2(100),
    telefono number,
    idEspecialidad number,
    foreign key (idEspecialidad) references ESPECIALIDAD_TECNICO(idEspecialidad)
);

create table CLIENTE(
    idCliente number primary key not null,
    nombre varchar2(20),
    apellido varchar2(20),
    direccion varchar2(100),
    correo varchar2(100),
    telefono number
);
create table PAGO(
    idPago number primary key not null,
    tipoPago varchar2(25)
);

create table STATUS_SOLICITUD(
    idStatus number primary key not null,
    status varchar2(25)
);

create table TIPO_MANTENIMIENTO(
    idMantenimiento number primary key not null,
    descMantenimiento varchar2(100)
);

--drop table CATALOGO_MATERIAL;
--drop table material;
--drop table SOLICITUD_MANTENIMIENTO;
create table SOLICITUD_MANTENIMIENTO(
    idSolicitud number primary key not null,
    fechaSolicitud date,
    identifEquipo varchar2(100),
    idCliente number,
    idMantenimiento number,
    idStatus number,
    idTecnico number,
    costo number,
    idPago number,
    fechaFinProvisto date,
    foreign key (idCliente) references CLIENTE(idCliente),
    foreign key (idMantenimiento) references TIPO_MANTENIMIENTO(idMantenimiento),
    foreign key (idStatus) references STATUS_SOLICITUD(idStatus),
    foreign key (idTecnico) references TECNICO(idTecnico),
    foreign key (idPago) references PAGO(idPago)
);
create table MATERIAL(
    idMaterial number primary key not null,
    descripcion varchar2(100)
);
create table CATALOGO_MATERIAL(
    idCatalogo number primary key not null,
    idSolicitud number,
    idMaterial number,
    cantidadMaterial number,
    foreign key(idSolicitud) references SOLICITUD_MANTENIMIENTO(idSolicitud),
    foreign key (idMaterial) references MATERIAL(idMaterial)
);

create table BITACORA(
    idSolicitud number,
    costo number,
    idTecnico number,
    idCliente number,
    fechaSolicitud date
);

create or replace procedure proc_insert_especialidad_Tec(
    v_idEspecialidad in ESPECIALIDAD_TECNICO.idEspecialidad%type, 
    v_especialidad in ESPECIALIDAD_TECNICO.especialidad%type)
is
    begin
        insert into ESPECIALIDAD_TECNICO values (v_idEspecialidad, v_especialidad);
end;

create or replace procedure proc_insert_tecnico(
    v_nombre in TECNICO.nombre%type,
    v_direccion in TECNICO.direccion%type,
    v_telefono in TECNICO.telefono%type,
    v_idEspecialidad in TECNICO.idEspecialidad%type)
is
begin 
    insert into TECNICO values (sec_tecnico.nextval, v_nombre, v_direccion, v_telefono, v_idEspecialidad);
end;

create or replace procedure proc_insert_cliente(
    v_nombre in cliente.nombre%type,
    v_apellido in cliente.apellido%type,
    v_direccion in cliente.direccion%type,
    v_correo in cliente.correo%type,
    v_telefono in cliente.telefono%type)
is
begin 
    insert into cliente values(sec_cliente.nextval, v_nombre, v_apellido, v_direccion, v_correo, v_telefono);
end;

create or replace procedure proc_insert_pago(
    v_idPago in pago.idPago%type,
    v_tipoPago in pago.tipoPago%type)
is
begin
    insert into PAGO values (v_idPago, v_tipoPago);
end;

create or replace procedure proc_insert_STATUS_SOLICITUD(
    v_idStatus in STATUS_SOLICITUD.idStatus%type,
    v_status in STATUS_SOLICITUD.status%type)
is
begin 
    insert into STATUS_SOLICITUD values (v_idStatus, v_status);
end;


create or replace procedure proc_insert_tipoMantenimiento(
    v_id in TIPO_MANTENIMIENTO.idMantenimiento%type,
    v_descripcion in TIPO_MANTENIMIENTO.descMantenimiento%type)
is
    v_costo2 number;
begin 
    insert into TIPO_MANTENIMIENTO values (v_id, v_descripcion);
end;

create or replace procedure proc_insert_solicitud(
    v_fechaSolicitud in solicitud_mantenimiento.fechasolicitud%type,
    v_IdentifEquipo in solicitud_mantenimiento.identifEquipo%type,
    v_idCliente in solicitud_mantenimiento.idCliente%type,
    v_idMantenimiento in solicitud_mantenimiento.idMantenimiento%type,
    v_idStatus in solicitud_mantenimiento.idStatus%type,
    v_idTecnico in solicitud_mantenimiento.idTecnico%type, 
    v_costo in solicitud_mantenimiento.costo%type,
    v_idPago in solicitud_mantenimiento.idPago%type,
    v_fechaFinProvisto in solicitud_mantenimiento.fechaFinProvisto%type)
is
    v_pago2 number;
    v_capturaCostoM number; --v_capturaCostoM = captura costo mantenimiento
begin 
    if  v_idPago=2 then     --idpago=2 es igual a pagar con tarjeta de debito o crédito
        v_capturaCostoM:= v_costo + (v_costo*0.05);--350+ 17.5 =367.5
        insert into SOLICITUD_MANTENIMIENTO values 
        (sec_solicitud.nextval, v_fechaSolicitud, v_IdentifEquipo, v_idCliente, v_idMantenimiento, v_idStatus, v_idTecnico, v_capturaCostoM, v_idPago, v_fechaFinProvisto);
    else
        insert into SOLICITUD_MANTENIMIENTO values 
        (sec_solicitud.nextval, v_fechaSolicitud, v_IdentifEquipo, v_idCliente, v_idMantenimiento, v_idStatus, v_idTecnico, v_costo, v_idPago, v_fechaFinProvisto);
    end if;
end;

create or replace procedure proc_insert_material(
    v_descripcion material.descripcion%type)
is
begin 
    insert into material values (sec_material.nextval, v_descripcion);
end;

create or replace procedure proc_catalogo_Material(
    v_idSolicitud in catalogo_material.idSolicitud%type,
    v_idMaterial in catalogo_material.idMaterial%type,
    v_cantidad in catalogo_material.cantidadMaterial%type)
is
begin 
    insert into catalogo_material values(SEC_CATALOGOMATERIAL.nextval, v_idSolicitud, v_idMaterial, v_cantidad);
end;




begin 
    proc_insert_especialidad_Tec(1, 'ELECTRONICA');
    proc_insert_especialidad_Tec(2, 'SOFTWARE');
    proc_insert_especialidad_Tec(3, 'SOPORTE DE SISTEMAS'); --
end;
--se eliminan primero estas, se deben de reiniciar las secuencias
--delete fromcatalogo_material;
--delete from solicitud material;
--delete from tecnico;
--que vengan las tablas qeu sean
--delete from especialidad_tecnico;

begin 
    proc_insert_tecnico('Darling Castellanos','zona 10 Guatemala',40404040,2); --ELECTRONICA
    proc_insert_tecnico('Gerardo Gordillo', 'lote 3-c7 palencia Guatemala',42424242, 1); --SOFTWARE
    proc_insert_tecnico('Monica Gutiérez', 'lote 19-s9 zona 21 Guatemala', 48484848,3);--SOPORTE DE SISTEMAS
    proc_insert_tecnico('Carlos Contreras', 'lote 17-c4 zona 1 Guatemala', 49494949,3);--SOPORTE DE SISTEMAS
    proc_insert_tecnico('Edy Colindres', 'lote 17-c4 zona 1 Guatemala', 47474747,3); --SOPORTE DE SISTEMAS
    proc_insert_tecnico('Jesús Molina','zona 10 Guatemala',41414141,2); --ELECTRONICA
end;
--update tecnico set nombre='Monica Gutiérez' where idTEcnico=3;

begin 
    proc_insert_cliente('Fernando','Montesinos','Amatitlán', 'fernando@gmail.com', 34353637);
    proc_insert_cliente('Cristian', 'Rojas', 'Petapa','cristian@gmail.com', 24242424); 
    proc_insert_cliente('Carlos', 'Maldonado', 'Mixco', 'carlos@gmail.com', 26262626); 
    proc_insert_cliente('Fatima', 'Montenegro', 'Amatitlán', 'fatima@gamil.com', 28282828); 
    proc_insert_cliente('Melendy', 'Carrasco', 'Palencia', 'melendy@gmail.com', 29292929);
    proc_insert_cliente('Sarah', 'Hernández', 'Villa Nueva', 'sarahgamil.com',30303030);
    proc_insert_cliente('Julio', 'López', 'Villa Nueva', 'ljulio@gmail.com',32323232);
    proc_insert_cliente('Vanessa','Corado','Villa Nueva','framirez@gmail.com' ,50505050);
    proc_insert_cliente('Ángela','Aguilar', 'El Fiscal', 'aaguilar@gmail.com', 52525252);
    proc_insert_cliente('Harold','Cancinos', 'Palencia', 'hcacncinos@gmail.com', 54545454);
    proc_insert_cliente('Joel','Sosa', 'Mixco', 'sjoel@gmail.com', 56565656);
    proc_insert_cliente('Rachel','Del Cid', 'Mixco', 'rachel@gmail.com', 57575757);
    proc_insert_cliente('Jadiel','Vázquez','El Fiscal', 'jvasquez@gmail.com', 59595959);
    proc_insert_cliente('Vanessa','Corado', 'Petapa', 'vanessa@gmail.com', 60606060);
end;
begin
    proc_insert_pago(1, 'efectivo');
    proc_insert_pago(2, 'tarjeta');
end;
begin 
    proc_insert_STATUS_SOLICITUD(1, 'en cola'); 
    proc_insert_STATUS_SOLICITUD(2, 'en proceso');
    proc_insert_STATUS_SOLICITUD(3, 'finalizado');
end;
begin 
    proc_insert_tipoMantenimiento(1, 'preventivo hardware'); 
    proc_insert_tipoMantenimiento(2, 'correctivo hardware');
    proc_insert_tipoMantenimiento(3, 'software');
    proc_insert_tipoMantenimiento(4, 'preventivo correctivo software-hardware');
end;

-- 1(preventivo hardware,3 SOPORTE DE SISTEMAS(2'correctivo hardware',1 electróncia)(3 software' 2 SOFTWARE)( 4 preventivo correctivo software-hardware 3 SOPORTE DE SISTEMAS)
--                   id    fechaS,    identifE, idCliente,idMantenimiento, idStatus, idTecnico, costo, idPago, fechaFin

--para idmantenimiento.software 3  tengo tecnico 1    
--para idMantenimiento.preventivo hardware 1  tengo los tecnicos 3, 4, 5
--para idMantenimiento.preventivo correctivo software-hardware 4  tengo los tecnicos 3, 4, 5
--para  idMantenimiento.correctivo 2 tengo  electronica 1 y 6
--para idStatus tengo 1:en cola 2:en proceso 3: finalizado
begin 
                    --(1, 'preventivo hardware) (2, 'correctivo hardware'), (3, 'software'),(4, 'preventivo correctivo )
--                   id    fechaS,    identifE, idCliente,idMantenimiento, idStatus, idTecnico, costo, idPago,   fechaFin
    proc_insert_solicitud('1/9/2020', 'a1', 1, 1, 1, 3, 290, 1, '9/9/2020');--1
    proc_insert_solicitud('2/9/2020', 'a2', 2, 1, 1, 2,  300, 1, '9/9/2020');--2
    proc_insert_solicitud('3/9/2020', 'a3', 3, 4, 2, 1, 350, 2, '10/9/2020');--3
    proc_insert_solicitud('4/9/2020', 'a4', 4, 3, 2, 4, 700, 2, '12/9/2020');--4
    proc_insert_solicitud('5/9/2020', 'a5', 5, 2,  2, 1, 250, 1, '15/9/2020');--5
    proc_insert_solicitud('6/9/2020', 'a6', 6, 4, 2, 1, 490, 1, '16/9/2020');--6
    proc_insert_solicitud('6/9/2020', 'a7', 2, 3,  2, 1, 290, 2, '16/9/2020');--7
    proc_insert_solicitud('7/9/2020', 'a8', 3,4, 2, 1, 500, 1, '18/9/2020');--8
    proc_insert_solicitud('8/9/2020', 'a9', 7, 1, 3, 2, 270, 2, '18/9/2020');--9
    proc_insert_solicitud('8/9/2020', 'a10', 8, 4, 1, 1, 500, 1, '18/9/2020');--10
    proc_insert_solicitud('8/9/2020', 'a11', 1, 2,  1, 6, 230, 2, '18/9/2020');--11
    proc_insert_solicitud('9/9/2020', 'a12', 9, 3,2, 1,  540, 1, '16/9/2020');--12
    proc_insert_solicitud('10/9/2020', 'a13', 10, 4, 2, 1, 900, 2, '10/10/2020');--13
    proc_insert_solicitud('11/9/2020', 'a14', 11, 3, 1, 1,  290, 1, '19/9/2020');--14
    proc_insert_solicitud('12/9/2020', 'a15', 12, 2,  3, 1, 225, 2, '30/9/2020');--15
    proc_insert_solicitud('13/9/2020', 'a16',  4, 4, 1, 3, 2000, 1, '30/9/2020');--16
    proc_insert_solicitud('14/9/2020', 'a17', 13, 1, 2,  2, 300, 2, '25/9/2020');--17
    proc_insert_solicitud('14/9/2020', 'a18',  14, 3, 2, 1, 400, 2, '30/9/2020');--18
    proc_insert_solicitud('14/9/2020', 'a19', 6, 4,  1, 5, 1800, 2, '26/9/2020');--19
    proc_insert_solicitud('16/9/2020', 'a20', 9, 1, 1, 4, 890, 2, '30/9/2020');--20
    proc_insert_solicitud('16/9/2020', 'a22', 11,  3, 3, 1, 200, 2, '30/10/2020');--21
    proc_insert_solicitud('17/9/2020', 'a22', 1, 3, 2, 1,  370, 1, '28/10/2020');--22
    proc_insert_solicitud('17/9/2020', 'a23', 5, 4, 1, 4, 1700, 2, '30/9/2020');--23
    proc_insert_solicitud('18/9/2020', 'a24', 3,4,  2,  5, 3000, 1, '29/9/2020');--24
    proc_insert_solicitud('19/9/2020', 'a25', 2, 1, 3, 3, 300, 1, '4/10/2020');--25
    proc_insert_solicitud('20/9/2020', 'a26', 12, 3, 2, 1, 310, 2, '6/10/2020');--26
    proc_insert_solicitud('20/9/2020', 'a27',  13, 2,  1, 6, 255, 2, '3/10/2020');--27
    proc_insert_solicitud('21/9/2020', 'a28', 14, 1,  2, 5, 290, 1, '30/9/2020');--28
    proc_insert_solicitud('24/9/2020', 'a29',  7,  4, 2, 3,  290, 1, '7/10/2020');--29
    proc_insert_solicitud('24/9/2020', 'a30',  8, 2,  3, 1,  350, 2, '11/10/2020');--30
    proc_insert_solicitud('25/9/2020', 'a31',  9, 3,  2, 1, 400, 1, '30/9/2020');--31
    proc_insert_solicitud('27/9/2020', 'a32',  10, 1, 3,  2, 340, 2, '30/10/2020');--32
    proc_insert_solicitud('27/9/2020', 'a33',  10, 3, 2, 1, 290, 2, '15/10/2020');--33
    proc_insert_solicitud('27/9/2020', 'a34', 13, 2, 2, 1, 1200, 1, '16/10/2020');--34
    proc_insert_solicitud('28/9/2020', 'a35', 13, 4, 3, 5, 700, 2, '30/10/2020');--35
    proc_insert_solicitud('28/9/2020', 'a36', 14, 2, 2, 6, 260, 1, '20/10/2020');--36
    proc_insert_solicitud('29/10/2020', '37', 2, 3,  3, 1, 310, 1, '12/11/2020');--37
    proc_insert_solicitud('29/10/2020', 'a38', 4, 2,  2, 1, 1900, 1, '30/11/2020');--38
    proc_insert_solicitud('29/10/2020', 'a39', 6, 1, 3, 5, 400, 2, '30/11/2020');--39
    proc_insert_solicitud('15/10/2020', 'a40', 9, 4, 1, 3, 1000, 2, '30/8/2020');--40
    proc_insert_solicitud('16/10/2020', 'a41',  11, 3, 3, 1, 289, 1, '3/11/2020');--41
    proc_insert_solicitud('17/10/2020', 'a42', 12, 4, 2, 3, 00, 2, '30/10/2020');--42
    proc_insert_solicitud('18/10/2020', 'a43', 9,  2,  2, 6, 2450, 1,'30/10/2020');--43
    proc_insert_solicitud('19/10/2020', 'a44', 10, 4,  1, 5, 18303, 2, '3/11/2020');--44
    proc_insert_solicitud('20/10/2020', 'a45',  11, 3, 2, 1, 200, 1, '30/10/2020');--45
    proc_insert_solicitud('21/8/2020', 'a46', 12, 4, 3,  3, 820, 2, '7/9/2020');--46
    proc_insert_solicitud('21/10/2020', 'a47', 13, 4, 2, 5, 1400, 1, '30/10/2020');--47
    proc_insert_solicitud('22/10/2020', 'a48', 14, 2, 1, 6,  300, 2, '30/10/2020');--48
    proc_insert_solicitud('23/10/2020', 'a48', 7, 2, 2, 1, 200, 1, '30/11/2020');--49
    proc_insert_solicitud('24/8/2020', 'a49', 8, 4, 3, 1,  460, 2, '30/9/2020');--50
    proc_insert_solicitud('24/10/2020', 'a50', 9, 3, 1, 1, 270, 1, '30/10/2020');--51
    proc_insert_solicitud('25/10/2020', 'a51', 10, 1, 2, 3, 900, 2, '30/11/2020');--52
    proc_insert_solicitud('26/10/2020', 'a52', 1, 3, 3, 1, 300, 1, '30/10/2020');--53
    proc_insert_solicitud('26/8/2020', 'a53', 12, 4, 2, 5, 2800, 2, '30/10/2020');--54
    proc_insert_solicitud('27/10/2020', 'a54', 2, 3, 1, 1, 200, 1, '16/11/2020');--55
    proc_insert_solicitud('27/10/2020', 'a55', 14, 4,  3, 4, 1700, 2, '30/10/2020');--56
    proc_insert_solicitud('28/10/2020', 'a56', 13,  3,  2,  1, 400, 1, '16/11/2020');--57
    proc_insert_solicitud('29/10/2020', 'a157', 14, 4, 1, 6, 2100, 2, '15/11/2020');--58
end;
--begin proc_insert_solicitud('3/2/2020', 'a160', 13, 2, 2, 3, 1000, 2, '3/8/2020');end;
--begin proc_insert_solicitud('17/10/2020', 'b32', 7, 2, 2, 3, 1200, 2, '3/11/2020');end;--para ejemplo

begin 
    proc_insert_material('PROCESADOR CORE I3 10TH GN');
    proc_insert_material('PROCESADOR CORE I5 10TH GN');
    proc_insert_material('PROCESADOR CORE I7 10TH GN');
    proc_insert_material('VENTILADOR CPU');
    proc_insert_material('HDD TOSHIBA');
    proc_insert_material('SSD TOSHIBA');
    proc_insert_material('TECLADO');
    proc_insert_material('MOUSE');
    proc_insert_material('TOUCHPAD');
    proc_insert_material('PUERTO USB V 3.0');
    proc_insert_material('MICRÓFONO LAPTOP');
    proc_insert_material('PANTALLA LAPTOP 14 PLULGADAS');
    proc_insert_material('PANTALLA LAPTOP 14 PULGADAS');
    proc_insert_material('PANTALLA LAPTOP 15 PULGADAS');
    proc_insert_material('CARGADOR LAPTOP 19.4V');
    proc_insert_material('BOCINA DE LAPTOP');
    proc_insert_material('LEX PANTALAL LAPTOP');
    proc_insert_material('SERIAL ATA');
    proc_insert_material('TARJETAS PCI');
    proc_insert_material('CARGADOR UNIVERSAL');
    proc_insert_material('QUEMADOR DE DVD INTERNO');
    proc_insert_material('ANTIVIRUS');
    proc_insert_material('PAQUETE DE OFFICE');
    proc_insert_material('LICENCIA WINDOWS');
    proc_insert_material('MEMORIA RAM');
    proc_insert_material('BATERILLA');
    proc_insert_material('FUENTE DE PODER');
    proc_insert_material('PLACA MADRE');
    proc_insert_material('PASTA TÉRMICA');
    proc_insert_material('ALCOHOL HISOPROPÍLICO');
    proc_insert_material('LICENCIA AUTOCAD') ;
    proc_insert_material('REFRIGERACIÓN POR AGUA');
    proc_insert_material('ADOBE ACROBAT PRO');
    proc_insert_material('AIR MINI GRAND PIANO');
    proc_insert_material('WINRAR');
    proc_insert_material('ADOBE PHOTOSHOP');
end;

begin --id está en el método. idSolicitud, idMaterial, cantidadMaterial
    proc_catalogo_Material(1, 29, 1);
    proc_catalogo_Material(1, 30, 1);
    proc_catalogo_Material(2, 29, 1);
    proc_catalogo_Material(2, 30, 1);
    proc_catalogo_Material(3, 29, 1);
    proc_catalogo_Material(3, 10, 1);
    proc_catalogo_Material(4, 23, 1);
    proc_catalogo_Material(5, 8, 1);
    proc_catalogo_Material(6, 17, 1);
    proc_catalogo_Material(6, 21, 1);
    proc_catalogo_Material(6, 22, 1);
    proc_catalogo_Material(7, 22, 1);
    proc_catalogo_Material(8, 15, 1);
    proc_catalogo_Material(8, 13, 1);
    proc_catalogo_Material(9, 11, 1);
    proc_catalogo_Material(9, 16, 1);
    proc_catalogo_Material(10, 9, 1);
    proc_catalogo_Material(10, 19, 1);
    proc_catalogo_Material(11, 4, 1);
    proc_catalogo_Material(12, 22, 1);
    proc_catalogo_Material(12, 23, 1);
    proc_catalogo_Material(13, 1, 1);
    proc_catalogo_Material(14, 22, 1);
    proc_catalogo_Material(15, 20, 1);
    proc_catalogo_Material(16, 3, 1);
    proc_catalogo_Material(17, 21, 1);
    proc_catalogo_Material(18, 31, 1 );
    proc_catalogo_Material(19, 2, 1);
    proc_catalogo_Material(20, 32, 1);
    proc_catalogo_Material(21, 33, 1);
    proc_catalogo_Material(22, 34, 1);
    proc_catalogo_Material(23, 14, 1);
    proc_catalogo_Material(23, 24, 1);
    proc_catalogo_Material(23, 27, 1);
    proc_catalogo_Material(24, 3, 1 );
    proc_catalogo_Material(24, 28, 1);
    proc_catalogo_Material(25, 36, 1);
    proc_catalogo_Material(26, 35, 1);
    proc_catalogo_Material(27, 25, 1);
    proc_catalogo_Material(28, 29, 1);
    proc_catalogo_Material(28, 30, 1);
    proc_catalogo_Material(30, 15, 1);
    proc_catalogo_Material(31, 35, 1);
    proc_catalogo_Material(31, 36, 1);
    proc_catalogo_Material(32, 7, 1);
    proc_catalogo_Material(33, 29, 1);
    proc_catalogo_Material(34, 6, 1);
    proc_catalogo_Material(35, 5, 1);
    proc_catalogo_Material(36, 9, 1);
    proc_catalogo_Material( 37, 34, 1);
    proc_catalogo_Material(38, 18, 1);
    proc_catalogo_Material(38, 28, 1);
    proc_catalogo_Material(39, 30, 1);
    proc_catalogo_Material(40, 12, 1);
    proc_catalogo_Material(40, 11, 1);
    proc_catalogo_Material(41, 35, 1);
    proc_catalogo_Material(42, 15, 1);
    proc_catalogo_Material(42, 25, 1);
    proc_catalogo_Material(43, 3, 1);
    proc_catalogo_Material(43, 27, 1);  
    proc_catalogo_Material(43, 8, 1);
    proc_catalogo_Material(44, 3, 1);
    proc_catalogo_Material(45, 36, 1);
    proc_catalogo_Material(46,15, 1);
    proc_catalogo_Material(46, 34, 1);
    proc_catalogo_Material(47, 26, 2);
    proc_catalogo_Material(48, 10, 3);
    proc_catalogo_Material(49, 4, 1);
    proc_catalogo_Material(50, 18, 2);
    proc_catalogo_Material(50, 22, 1);
    proc_catalogo_Material(51, 22, 1);
    proc_catalogo_Material(52, 28, 1);
    proc_catalogo_Material(53, 22, 1);
    proc_catalogo_Material(54, 13, 1);
    proc_catalogo_Material(54, 25, 1);
    proc_catalogo_Material(55, 36, 1);
    proc_catalogo_Material(56, 3, 1);
    proc_catalogo_Material(57, 23, 1);
    proc_catalogo_Material(58, 11, 1);
    proc_catalogo_Material(58, 6, 1); 
end;






--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++funciones++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-------------------------------------------------
--dada dos fechas devuelva la cantidad total de dinero de lo que se cobró entre las fechas esecificadas, 
/*select FECHASOLICITUD, COSTO from solicitud_mantenimiento
     WHERE fechaSOlicitud between '28/9/2020' and '3/10/2020';*/

create or replace function func_dinero_entre_dos_fechas( 
    fecha1 date, fecha2 date)
    return float
is
    v_sumaCosto float;
begin 
    select sum(costo) into v_sumaCosto from solicitud_mantenimiento
     where fechaSOlicitud between fecha1 and fecha2;
    return v_sumaCosto;
end; 

--llamada de la función    
declare 
    sumaMontoDosFechas float;
begin 
    sumaMontoDosFechas:= func_dinero_entre_dos_fechas('28/9/2020', '3/10/2020');
    DBMS_OUTPUT.put_line('el monto por servicios entre las dos fechas  28/9/2020  y 3/10/2020 es: '||sumaMontoDosFechas);
end;







-----------------------------------------------------------------------------------------2 función
--una que debuelva el técnico que más mantenimientos ha hecho
select  idTecnico, cantidadMantenimiento from ( 
select idTecnico, count(*) cantidadMantenimiento from solicitud_mantenimiento
group by idTecnico 
order by cantidadMantenimiento desc-- también funciona   --count(*) desc
)
where rownum=1;

--+++para verivicar la efectividad de la consulta
select idTecnico, count(*) cantidadMantenimiento from solicitud_mantenimiento
group by idTecnico 
order by count(*) desc;
   

/*--no necesario
select idTecnico, count(idTecnico) as cantidadAtendido, sum(costo) from
solicitud_mantenimiento group by idTecnico;-- order by  cantidadAtendido desc;*/





--------------------------------------------------------------------------------------función 3
--una que debuelva cuál es el material más utilizado en  los mantenimientos

--*************************** gracias al fin, pasé horas investigando(extras)
select  idMaterial, DescMaterial, cantidadutilizado from ( 
select catM.idMaterial as idMaterial, mat.descripcion as DescMaterial, 
    count(*) as cantidadUtilizado from catalogo_material catM
        inner join material mat on mat.idMaterial=catM.idMaterial
    group by catM.idMaterial, mat.DESCRIPCION
    order by cantidadutilizado desc
)  
where rownum=1;

---++ para ver si nuestra consulta arriba correcta
select catM.idMaterial, mat.descripcion, count(*) as cantidadUtilizado from catalogo_material catM
    inner join material mat on mat.idMaterial=catM.idMaterial
    group by catM.idMaterial, mat.DESCRIPCION 
    order by cantidadUtilizado desc;


/*select  idmaterial, cantidadutilizado from ( 
select mat.idMaterial, count(*) as cantidadUtilizado from catalogo_material catM
        inner join material mat on mat.idMaterial=catM.idMaterial
    group by mat.idMaterial
    order by cantidadutilizado desc
)  
where rownum=1;*/








--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++triggers+++++++++++++++++++++++++++++++++++++++++++++
--cuando se inserte en mantenimiento un trigger que almacene en la tabla bitácora

--DROP TRIGGER tr_inserSolicitud_bitacora;
create or replace trigger tr_inserSolicitud_a_bitacora
    after insert on solicitud_mantenimiento
    for each row
   
begin 
    insert into bitacora values (:new.idSolicitud, :new.costo, :new.idTecnico, :new.idCliente, :new.fechaSolicitud);
end;








--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++consultas++++++++++++++++++++++++++++++++++++++++++++++
----------------------------------------------------------------------1
/*una que debuelva el IDSolicitud, el nombre del cliente, nombre del técnico, la especialidad del técnico, y el tipo de pago
de todas las solicitudes cuyo estatus sea en proceso, y que la cantidad de días transcurridos sea mayor a diez*/
--select idStatus from status_solicitud where status='en proceso';--muestra el id del estado en proceso
--select * from status_solicitud;

select sm.idSolicitud, c.nombre as nombre_cliente, t.nombre as tecnico_encargado, 
    et.especialidad as especialidad_tecnico , p.tipoPago, ss.status as estado,
    sm.fechasolicitud
from solicitud_mantenimiento sm
    inner join cliente c on c.idCliente=sm.idCliente
    inner join status_solicitud ss on ss.idstatus=sm.idStatus
    inner join pago p on p.idPago=sm.idPago
    inner join tecnico t on t.idTecnico=sm.idTecnico
    inner join especialidad_tecnico et on et.idEspecialidad=t.idEspecialidad
--where sm.idStatus=2
where sm.idStatus=(select idStatus from status_solicitud where status='en proceso')
    and fechaSolicitud<=sysdate-10 --le quitamos 10 dias a la fecha actual
order by  fechaSolicitud desc; --idSolicitud;










---------------------------------------------------------------------- 2
--pasado un IDCliente, que cuente cuantos están en estado proceso y finalizado     
--select *from  status_solicitud;
select sm.idStatus, ss.status, count(sm.idStatus) as cantidad from SOLICITUD_MANTENIMIENTO sm --id_estado
    inner join cliente c on c.idCliente=sm.idCliente 
    inner join status_solicitud ss on ss.idstatus=sm.idStatus
where sm.idCliente=(select idCliente from cliente where idCliente=2) --´pasamos idCliente
 and (sm.idStatus=(select idstatus from status_solicitud where status='en proceso')
  or sm.idStatus=(select idstatus from status_solicitud where status='finalizado'))
 /*where sm.idCliente=2    ---vida fácil
    and (sm.idstatus=2 or sm.idStatus=3)*/ --vida fácil
 group by sm.idStatus, ss.status;


--para ver total en estado proceso y finalizado
select count(idStatus) as cli_2_st_espera_finalizado from  solicitud_mantenimiento
where idCliente=2 and (idStatus<>1);







------------------------------------------------------------------------------ 3
--dada dos fechas que diga cuantos mantenimiento se han realizaco con enfectivo y tarjeta de crédito, 
--tomar en cunta que el estatús sea finalizado

select sm.idPago, p.tipoPago, count(sm.idSolicitud)as catnidadSolicitud from solicitud_mantenimiento sm
    inner join pago p on p.idPago=sm.idPago
    where sm.fechasolicitud between '10/8/2020' and '17/10/2020' and 
    sm.idStatus=(select idStatus from status_Solicitud where status='finalizado') --que capture el id estado finalizado
group by sm.idPago, p.tipoPago
order by catnidadSolicitud desc;





https://www.oracletutorial.com/oracle-basics/oracle-group-by/

