using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web;
using MobiPlusTools;


namespace DAL
{
    public class ClientDAL
    {
        private static string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

        private static SqlConnection Connect()
        {
            SqlConnection s = new SqlConnection(ConfigurationManager.ConnectionStrings["ClientConnectionString"].ConnectionString);
            return s;

        }
        private static SqlCommand GetCommand(string ProcedureName)
        {
            SqlCommand sqlComm = new SqlCommand(ProcedureName, Connect());
            sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
            sqlComm.CommandType = CommandType.StoredProcedure;
            return sqlComm;
        }
        public static DataTable RunQuery(string Query)
        {
            DataTable results = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ClientConnectionString"].ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand(Query, conn))
                    {
                        command.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                        using (SqlDataAdapter dataAdapter = new SqlDataAdapter(command))
                            dataAdapter.Fill(results);
                    }
                }
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }
            return results;
        }
        public static DataTable RunSP(string spName, string spParameters)
        {
            try
            {
                //spParameters exmpale = "UserID:1;WidgetID:1;";
                DataSet ds = new DataSet(spName);
                SqlCommand sqlComm = GetCommand(spName);

                string[] arrParams = spParameters.Split(';');
                for (int i = 0; i < arrParams.Length; i++)
                {
                    string[] arrParamValue = arrParams[i].Split(':');
                    if (arrParamValue.Length > 1)
                        sqlComm.Parameters.AddWithValue("@" + arrParamValue[0], arrParamValue[1]);
                }

                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = sqlComm;

                da.Fill(ds);
                return ds.Tables[0];
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                return new DataTable();
            }
        }
        public static DataSet RunSPForCtl(string spName, string spParameters)
        {
            try
            {
                //spParameters exmpale = "UserID:1;WidgetID:1;";
                DataSet ds = new DataSet(spName);
                SqlCommand sqlComm = GetCommand(spName);

                string[] arrParams = spParameters.Split(';');
                for (int i = 0; i < arrParams.Length; i++)
                {
                    string[] arrParamValue = arrParams[i].Split(':');
                    if (arrParamValue.Length > 1)
                        sqlComm.Parameters.AddWithValue("@" + arrParamValue[0], arrParamValue[1]);
                }

                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = sqlComm;

                da.Fill(ds);
                return ds;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                return new DataSet();
            }
        }
        
    }
}
