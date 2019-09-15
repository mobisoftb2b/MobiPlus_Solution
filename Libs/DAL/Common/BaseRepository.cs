using MobiPlusTools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Common
{
    public class BaseRepository
    {
        private static readonly string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

        public void HandleError(Exception ex)
        {
            Tools.HandleError(ex, LogDir);
        }

        public void AddRowToLog(string message) {
            Tools.AddRowToLog(message, LogDir);
        }



    }
}
