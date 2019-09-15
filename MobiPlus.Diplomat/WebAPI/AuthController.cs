using System;
using System.IO;
using System.Threading.Tasks;
using MobiPlus.BusinessLogic.Auth;
using MobiPlus.Models.Auth;
using System.Web;
using System.Web.Hosting;
using System.Web.Mvc;

namespace MobiPlus.Diplomat.WebAPI
{
    [AllowAnonymous]
    public class AuthController : System.Web.Http.ApiController
    {
        [HttpGet]
        public string Index()
        {
            return CommonManager.GetIP(new HttpRequestWrapper(HttpContext.Current.Request));
        }

        [HttpPost]
        public async Task<UserModel> UserLogin([System.Web.Http.FromBody] UserParams userParams)
        {
            var user = await new UserService().UserLoginTask(new UserParams { UserName = userParams.UserName, UserPassword = userParams.UserPassword });
            try
            {
                string json1 = HostingEnvironment.MapPath(@"~/client/share/server/defaultFilter.json");
                File.WriteAllText(json1, Newtonsoft.Json.JsonConvert.SerializeObject(user.FilterParams));
            }
            catch (Exception)
            {

            }
            return user;
        }

        [HttpPost]
        public async Task<UserModel> Authenticate(string userName, string password)
        {
            return await new UserService().Authenticate(userName, password);
        }

        [HttpPost]
        public void Logout()
        {
            string json1 = HostingEnvironment.MapPath(@"~/client/share/server/defaultFilter.json");
            if (File.Exists(json1)) File.Delete(json1);
        }
    }
}
