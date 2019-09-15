using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using MobiPlus.Models.Dashboard;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MobiPlus.Models.Auth
{
    public class UserModel: IdentityUser
    {
        public long? UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Description { get; set; }
        public string Token { get; set; }
        public bool isAuthenticated { get; set; }
        public long? UpdateState { get; set; }        
        public FilterParams FilterParams { get; set; }


        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<UserModel> manager, string authenticationType)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            //var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);
            var identity = new ClaimsIdentity();
            identity.AddClaim(new Claim(ClaimTypes.Name, this.UserName));
            return await Task.FromResult(identity);
            // Add custom user claims here
            // userIdentity;
        }

    }

    //public partial class UserManager<TUser> where TUser: UserModel
    //{
    //    public  Task<ClaimsIdentity> CreateIdentityAsync(TUser user, string authenticationType)
    //    {
    //        var identity = new ClaimsIdentity();
    //        identity.AddClaim(new Claim(ClaimTypes.Name, user.UserName));
    //        return Task.FromResult(identity);
    //    }
    //}

    public class UserParams
    {
        public long? UserID { get; set; }
        public string UserName { get; set; }
        public string UserPassword { get; set; }
    }
}
