package expire.expire;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.microsoft.windowsazure.mobileservices.MobileServiceClient;

import java.net.MalformedURLException;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        try {
            AzureServiceAdapter.Initialize(this);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }

    }
}
