using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(eXpireService.Startup))]

namespace eXpireService
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureMobileApp(app);
        }
    }
}