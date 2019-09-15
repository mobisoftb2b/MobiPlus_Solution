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
    public class GeneralDAL
    {
        private static string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

        private static SqlConnection Connect()
        {
            try
            {
                SqlConnection s = new SqlConnection(ConfigurationManager.ConnectionStrings["WebConnectionString"].ConnectionString);
                return s;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }

        }
        private static SqlConnection Connect(string ConString)
        {
            try
            {
                SqlConnection s = new SqlConnection(ConString);
                return s;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }

        }
        private static SqlCommand GetCommand(string ProcedureName)
        {

            try
            {
                SqlConnection sqlCon = Connect();
                SqlCommand sqlComm = new SqlCommand(ProcedureName, sqlCon);
                sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                sqlComm.CommandType = CommandType.StoredProcedure;
                return sqlComm;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }

        }
        private static SqlCommand GetCommand(string ProcedureName, string ConString)
        {
            try
            {
                SqlConnection sqlCon = Connect(ConString);
                SqlCommand sqlComm = new SqlCommand(ProcedureName, sqlCon);
                sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                sqlComm.CommandType = CommandType.StoredProcedure;
                return sqlComm;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }
        }

        public static DataTable GetUserMap(string User, string Date, string Ezor, string Maslol, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetUserMap", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetUserMap");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@User", User);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@Ezor", Ezor);
                    sqlComm.Parameters.AddWithValue("@Maslol", Maslol);

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
        }
        public static DataTable GetUserMapAllPoints(string User, string Date, string Ezor, string Maslol, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetUserMapAllPoints", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetUserMapAllPoints");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@User", User);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@Ezor", Ezor);
                    sqlComm.Parameters.AddWithValue("@Maslol", Maslol);

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
        }
        public static DataTable GetUserSumVisit(string User, string Date, string Filter, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetUserSumVisit", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetUserSumVisit");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@User", User);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@Filter", Filter);

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
        }
        public static DataTable ETA_GetETAQData(string AgentID, string CustKey1, string CustKey2, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("ETA_GetETAQData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("ETA_GetETAQData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@CustKey1", CustKey1);
                    sqlComm.Parameters.AddWithValue("@CustKey2", CustKey2);

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
        }
        public static DataTable GetLocationToSMS(string SMSID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetLocationToSMS", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetLocationToSMS");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@SMSID", SMSID);

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
        }
    }
}
