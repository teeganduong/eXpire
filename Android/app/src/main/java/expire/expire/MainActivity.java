package expire.expire;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;

import com.microsoft.windowsazure.mobileservices.MobileServiceClient;
import com.microsoft.windowsazure.mobileservices.table.MobileServiceTable;

import java.net.MalformedURLException;
import java.util.concurrent.ExecutionException;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        try {

            // Establish connection through service
            AzureServiceAdapter.Initialize(this);
            AzureServiceAdapter service = AzureServiceAdapter.getInstance();
            MobileServiceClient client = service.getClient();
            MobileServiceTable<FoodItem> table = client.getTable("FoodItems", FoodItem.class);

            // Query
            FoodItem item = table.lookUp(1).get();
            String name = item.toString();
            TextView viewName = null;
            viewName.setText(name);

        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }

    }
}
