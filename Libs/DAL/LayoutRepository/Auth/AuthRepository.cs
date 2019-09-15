using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobiPlus.Models.Auth;
using MobiPlus.Models.Common;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity;
using DAL.Common;
using MobiPlus.Models.Dashboard;

namespace DAL.LayoutRepository.Auth
{
    public class AuthRepository : BaseRepository, IRepository<UserModel, UserParams>
    {
        private UserManager<IdentityUser> _userManager;

        public AuthRepository()
        {
            _userManager = new UserManager<IdentityUser>(new UserStore<IdentityUser>());
        }

        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    _userManager.Dispose();
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }
        #endregion

        public Task<IEnumerable<UserModel>> GetAll()
        {
            throw new NotImplementedException();
        }


        #region GetUserByIID

        public async Task<UserModel> GetDataByID(UserParams param)
        {
            return await Task.Run(() => SelectUserByID(param));
        }

        public async Task<IEnumerable<UserModel>> GetFilteredData(UserParams param)
        {
            throw new NotImplementedException();
        }

        public UserModel SelectUserByID(UserParams param)
        {
            var result = new UserModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.MPLayout_GetUsers(param.UserID)
                        .Select(a => new UserModel
                        {
                            Description = a.Description,
                            FirstName = a.UserName.Substring(0, a.UserName.IndexOf(" ", StringComparison.Ordinal)),
                            LastName = a.UserName.Substring(a.UserName.IndexOf(" ", StringComparison.Ordinal) + 1),
                            UserID = a.UserID
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }
        #endregion


        #region UserLogin

        public async Task<IdentityUser> FindUser(string userName, string password)
        {
            IdentityUser user = await _userManager.FindAsync(userName, password);

            return user;
        }

        public async Task<UserModel> UserLoginAsync(UserParams userParams)
        {
            return await Task.Run(() => UserLogin(userParams));
        }
        public UserModel UserLogin(UserParams userParams)
        {
            var result = new UserModel();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_UserLogin(userParams.UserName, userParams.UserPassword, null)
                        .Select(a => new UserModel
                        {
                            Description = a.Description,
                            FirstName = a.Name,
                            UserID = a.UserID,
                            Token = SecurityManager.GenerateToken(userParams.UserName, userParams.UserPassword, "127.0.0.1", a.Name, 2),
                            isAuthenticated = true,
                            UpdateState = 0,
                            UserName = a.UserName,
                            Email = "qwert@qwert.com",
                            SecurityStamp = Guid.NewGuid().ToString(),
                            PasswordHash = userParams.UserPassword,
                            FilterParams = new FilterParams
                            {
                                CountryID = a.CountryID,
                                DistrID = a.DistributionCenterID,
                                CountryLanLng = a.LatLng,
                                IsUpdated = false,
                                AgentName = string.Empty
                            }
                        }).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                result.isAuthenticated = false;
                HandleError(ex);
            }
            return result;

        }


        #endregion



    }
}
