using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Collections.ObjectModel;

namespace WFSSDevOps
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Execute(object sender, EventArgs e)
        {
            // Create the InitialSessionState Object
            InitialSessionState iss = InitialSessionState.CreateDefault2();

            // Initialize PowerShell Engine
            var shell = PowerShell.Create();
            string powershell = powershellHdn.Value;
            string redirect = redirectHdn.Value;

            // Add the command to the Powershell Object
            shell.Commands.AddScript(powershell);
            // Execute the script 
            try
            {
                Collection<PSObject>psObjects = shell.Invoke();
                Response.Redirect(redirect, false);
            }
            catch (ActionPreferenceStopException Error) { Error.ToString(); }
            catch (RuntimeException Error) { Error.ToString(); };
        }
    }
}