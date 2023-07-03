using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;

/// <summary>
/// Descripción breve de conn
/// </summary>
public class conn
{
	public conn()
	{
		//
		// TODO: Agregar aquí la lógica del constructor
		//
	}

    public static SqlConnection conecta()
    {
        SqlConnection sqlcon = new SqlConnection(ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
        return sqlcon;
    }
}