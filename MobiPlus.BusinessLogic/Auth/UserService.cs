using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using DAL.LayoutRepository.Auth;
using MobiPlus.Models.Auth;
using MobiPlus.Models.Common;
using MobiPlus.Models.Interfaces;
using Newtonsoft.Json;
using System.Data;
using System.Web.Script.Serialization;

namespace MobiPlus.BusinessLogic.Auth
{
    public class UserService : IRepository<UserModel, UserParams>, IUserServices<UserModel>
    {
        protected AuthRepository repository;

        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    repository.Dispose();
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }

        #endregion

        public UserService()
        {
            this.repository = new AuthRepository();
        }

        public async Task<UserModel> GetDataByID(UserParams param)
        {
            return await this.repository.GetDataByID(param);
        }

        public async Task<IEnumerable<UserModel>> GetFilteredData(UserParams param)
        {
            throw new NotImplementedException();
        }

        public async Task<UserModel> UserLoginTask(UserParams userParams)
        {
            return await this.repository.UserLoginAsync(userParams);
        }

        public async Task<UserModel> Authenticate(string userName, string password)
        {
            return await this.repository.UserLoginAsync(new UserParams { UserName = userName, UserPassword = password });
        }

        //public string MPUserLogin(string userName, string password, string userIP, string conString)
        //{
        //    return JsonConvert.SerializeObject(DAL.LayoutDAL.MPUserLogin(userName, password, userIP, conString), Formatting.Indented);
        //}

        public string MPUserLogin(string userName, string password, string userIP, string conString)
        {
            var rows = new List<Dictionary<string, object>>();
            var serializer = new JavaScriptSerializer();
            var dt = DAL.LayoutDAL.MPUserLogin(userName, password, userIP, conString);

            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }
    }
}
