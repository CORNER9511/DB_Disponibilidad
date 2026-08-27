-------------------------------------------------------
-- PAQUETE PKG_APP_INDISPONIBILIDADES - DB_DISPONIBILIDAD
-------------------------------------------------------

--  DDL for Package PKG_APP_INDISPONIBILIDADES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "DB_DISPONIBILIDAD"."PKG_APP_INDISPONIBILIDADES" IS

G_NOMB_PACKAGE VARCHAR2(30) := 'PKG_APP_INDISPONIBILIDADES';
G_COD_ERR_GENERICO NUMBER := 400;
G_COD_EJECUCION_OK NUMBER := 200;
G_COD_NO_ENCONTRADO NUMBER := 404;
G_MSG_EJECUCION_OK VARCHAR2(30) := 'Ejecucion exitosa';
G_MSG_NO_ENCONTRADO VARCHAR2(50) := 'No hay datos para mostrar';
G_MSG_ERR_GENERICO VARCHAR2(100) := 'Oh oh, se presento un problema, por favor comunicate con el administrador';
G_MSG_PARAM_NULOS VARCHAR2(100) := '!ERROR!, no se permiten parametros nulos';
G_ALTER_SESSION_LANG VARCHAR2(100) := 'ALTER SESSION SET NLS_LANGUAGE = ''SPANISH'' ';

    --SP Registra Log de Errores
    PROCEDURE prc_registra_error_bd(pkg_error  in varchar2,
                                    prc_error in varchar2,
                                    cod_error in number,
                                    desc_error in clob);
    
    --SP registra tabla tbl_dominios                               
    PROCEDURE prc_reg_tbl_dominios(p_dominio_label in varchar2,
                                   p_dominio_esquema in varchar2,
                                   p_dominio_desc in varchar2,
                                   p_usuario_reg in varchar2,
                                   p_cod_error out number,
                                   p_msg_error out varchar2);
                                     

END PKG_APP_INDISPONIBILIDADES;

/
--------------------------------------------------------
--  DDL for Package Body PKG_APP_INDISPONIBILIDADES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DB_DISPONIBILIDAD"."PKG_APP_INDISPONIBILIDADES" IS

  --SP Registra Log de Errores
  PROCEDURE prc_registra_error_bd(pkg_error in varchar2,
                            prc_error in varchar2,
                            cod_error in number,
                            desc_error in clob) is

  BEGIN

      INSERT INTO tbl_log_errores (fecha, pkg_error, prc_error, cod_error, desc_error)
      VALUES (SYSDATE,PKG_ERROR,PRC_ERROR,COD_ERROR,DESC_ERROR);
      COMMIT;

  EXCEPTION
  WHEN OTHERS THEN
    Raise;

  END prc_registra_error_bd;

  --SP registra tabla tbl_dominios                               
  PROCEDURE prc_reg_tbl_dominios(p_dominio_label in varchar2,
                                 p_dominio_esquema in varchar2,
                                 p_dominio_desc in varchar2,
                                 p_usuario_reg in varchar2,
                                 p_cod_error out number,
                                 p_msg_error out varchar2) is
                                   
     v_cod number;
     v_msg clob;                                
     
     BEGIN
       
        execute immediate G_ALTER_SESSION_LANG;
       
        --Se inserta o actualiza la informacion
        MERGE INTO tbl_dominios p
        USING (SELECT (p_dominio_label || p_dominio_esquema)  AS llave FROM dual) s ON ((p.dominio_label || p.dominio_esquema) = s.llave)
        WHEN MATCHED THEN
          UPDATE SET
            p.fecha_ins = sysdate, 
            p.usuario_reg = p_usuario_reg, 
            p.dominio_desc = p_dominio_desc
            
        WHEN NOT MATCHED THEN
          INSERT (dominio_label, dominio_desc, dominio_esquema, fecha_ins, usuario_reg)
          VALUES (p_dominio_label,
                  p_dominio_desc,
                  p_dominio_esquema,
                  sysdate,
                  p_usuario_reg);

        COMMIT;

        p_cod_error := G_COD_EJECUCION_OK;
        p_msg_error := G_MSG_EJECUCION_OK;
        
  EXCEPTION
  WHEN OTHERS THEN
    p_cod_error := G_COD_ERR_GENERICO;
    p_msg_error := G_MSG_ERR_GENERICO;
    v_cod := sqlcode;
    v_msg := sqlerrm;
    PRC_REGISTRA_ERROR_BD(G_NOMB_PACKAGE,'prc_reg_tbl_dominios',v_cod,v_msg);

                                   
  END prc_reg_tbl_dominios;                                   

END PKG_APP_INDISPONIBILIDADES;

/
--------------------------------------------------------
