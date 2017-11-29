package expire.testapp;

import android.app.FragmentManager;
import android.content.ContentValues;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.app.DialogFragment;

import expire.testapp.db.FoodItemContract;
import expire.testapp.db.FoodItemDbHelper;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements DialogInterface.OnCancelListener,DialogInterface.OnDismissListener {
    private static final String TAG = "MainActivity";
    private FoodItemDbHelper mHelper;
    public ListView mFoodItemListView;
    private ArrayAdapter<String> mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mHelper = new FoodItemDbHelper(this);
        mFoodItemListView = (ListView) findViewById(R.id.list_todo);

        final ImageButton a=(ImageButton) findViewById(R.id.setting);

        a.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent aa= new Intent(MainActivity.this , Settings.class);
                startActivity(aa);
            }
        });

        updateUI();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public void onDismiss(final DialogInterface dialog) {
        updateUI();
    }
    @Override
    public void onCancel(final DialogInterface dialog) {
        updateUI();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_add_item:
                final EditText itemEditText = new EditText(this);
                final EditText itemTypeEditText = new EditText(this);
                FragmentManager frag = getFragmentManager();
                DialogFragment dialog = new AddItemDialogFragment();
                dialog.show(frag, null);


                return true;

            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void deleteTask(View view) {
        View parent = (View) view.getParent();
        TextView taskTextView = (TextView) parent.findViewById(R.id.item_title);
        String task = String.valueOf(taskTextView.getText());
        SQLiteDatabase db = mHelper.getWritableDatabase();
        db.delete(FoodItemContract.FoodItemEntry.TABLE,
                FoodItemContract.FoodItemEntry.COL_FOOD_TITLE + " = ?",
                new String[]{task});
        db.close();
        updateUI();
    }

    public void updateUI() {
        ArrayList<String> taskList = new ArrayList<>();
        SQLiteDatabase db = mHelper.getReadableDatabase();

        Cursor cursor = db.query(FoodItemContract.FoodItemEntry.TABLE,
                new String[]{FoodItemContract.FoodItemEntry._ID, FoodItemContract.FoodItemEntry.COL_FOOD_TITLE,
                        FoodItemContract.FoodItemEntry.COL_FOOD_TYPE, FoodItemContract.FoodItemEntry.COL_QUANTITY,
                        FoodItemContract.FoodItemEntry.COL_EXPIRE_DATE, FoodItemContract.FoodItemEntry.COL_EXPIRED},
                null, null, null, null, null);
        while (cursor.moveToNext()) {
            int idx = cursor.getColumnIndex(FoodItemContract.FoodItemEntry.COL_FOOD_TITLE);
            taskList.add(cursor.getString(idx));
        }

        if (mAdapter == null) {
            mAdapter = new ArrayAdapter<>(this,
                    R.layout.item_todo,
                    R.id.item_title,
                    taskList);
            mFoodItemListView.setAdapter(mAdapter);
        } else {
            mAdapter.clear();
            mAdapter.addAll(taskList);
            mAdapter.notifyDataSetChanged();
        }

        cursor.close();
        db.close();
    }
}
