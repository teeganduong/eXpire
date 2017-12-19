using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity;
using System.Web.Http;
using Microsoft.Azure.Mobile.Server;
using Microsoft.Azure.Mobile.Server.Authentication;
using Microsoft.Azure.Mobile.Server.Config;
using eXpireService.DataObjects;
using eXpireService.Models;
using Owin;

namespace eXpireService
{
    public partial class Startup
    {
        public static void ConfigureMobileApp(IAppBuilder app)
        {
            HttpConfiguration config = new HttpConfiguration();

            //For more information on Web API tracing, see http://go.microsoft.com/fwlink/?LinkId=620686 
            config.EnableSystemDiagnosticsTracing();

            new MobileAppConfiguration()
                .UseDefaultConfiguration()
                .ApplyTo(config);

            // Use Entity Framework Code First to create database tables based on your DbContext
            Database.SetInitializer(new eXpireInitializer());

            // To prevent Entity Framework from modifying your database schema, use a null database initializer
            // Database.SetInitializer<eXpireContext>(null);

            MobileAppSettingsDictionary settings = config.GetMobileAppSettingsProvider().GetMobileAppSettings();

            if (string.IsNullOrEmpty(settings.HostName))
            {
                // This middleware is intended to be used locally for debugging. By default, HostName will
                // only have a value when running in an App Service application.
                app.UseAppServiceAuthentication(new AppServiceAuthenticationOptions
                {
                    SigningKey = ConfigurationManager.AppSettings["SigningKey"],
                    ValidAudiences = new[] { ConfigurationManager.AppSettings["ValidAudience"] },
                    ValidIssuers = new[] { ConfigurationManager.AppSettings["ValidIssuer"] },
                    TokenHandler = config.GetAppServiceTokenHandler()
                });
            }
            app.UseWebApi(config);
        }
    }

    public class eXpireInitializer : CreateDatabaseIfNotExists<eXpireContext>
    {
        protected override void Seed(eXpireContext context)
        {
            List<FoodItem> foodItems = new List<FoodItem>
            {
                //new FoodItem { Id = Guid.NewGuid().ToString(), Text = "First item", Complete = false },
                //new FoodItem { Id = Guid.NewGuid().ToString(), Text = "Second item", Complete = false },
                new FoodItem
                {
                    FoodItemID = 1,
                    Category = FoodType.Fruit,
                    BoughtDate = new DateTime(2017, 1, 1),
                    ExpirationDate = new DateTime(2017, 1, 8),
                    DaysToExpire = 7,
                    Description = "Base Food",
                    SpoonacularID = 1,
                },
            };

            foreach (FoodItem foodItem in foodItems)
            {
                context.Set<FoodItem>().Add(foodItem);
            }

            base.Seed(context);
        }
    }
}

