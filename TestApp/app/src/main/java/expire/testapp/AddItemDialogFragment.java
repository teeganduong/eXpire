package expire.testapp;

import android.app.DialogFragment;
import android.app.Dialog;
import android.content.ContentValues;
import android.content.DialogInterface;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.DatePicker;
import android.widget.ListView;
import android.widget.TextView;

import java.util.ArrayList;

import expire.testapp.db.FoodItemContract;
import expire.testapp.db.FoodItemDbHelper;

/**
 * Created by Teeq on 11/16/2017.
 */

public class AddItemDialogFragment extends DialogFragment {
    private FoodItemDbHelper mHelper;
    public ListView mFoodItemListView;
    private ArrayAdapter mAdapter;
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();
        mHelper = new FoodItemDbHelper(getActivity());
        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        final View v = inflater.inflate(R.layout.add_item_dial, null);
        builder.setView(v)
                // Add action buttons
                .setPositiveButton(R.string.add, new DialogInterface.OnClickListener() {
                    @Override
                        public void onClick(DialogInterface dialog, int which) {
                            //get the values of the dialog into strings
                            TextView foodTitleView = (TextView) v.findViewById(R.id.FoodTitle);
                            String foodItem = String.valueOf(foodTitleView.getText());

                            TextView foodTypeView = (TextView) v.findViewById(R.id.FoodType);
                            String foodType = String.valueOf(foodTypeView.getText());

                            TextView quantityView = (TextView) v.findViewById(R.id.Quantity);
                            String quantity = String.valueOf(quantityView.getText());

                            DatePicker expireDateView = (DatePicker) v.findViewById(R.id.expireDate);
                            String expireYear = String.valueOf(expireDateView.getYear());
                            String expireMonth = String.valueOf(expireDateView.getDayOfMonth());
                            String expireDay = String.valueOf(expireDateView.getDayOfMonth());
                            String expireDate = expireYear + "/" + expireMonth + "/" + expireDay;

                            SQLiteDatabase db = mHelper.getWritableDatabase();

                            ContentValues values = new ContentValues();
                            values.put(FoodItemContract.FoodItemEntry.COL_FOOD_TITLE, foodItem);
                            values.put(FoodItemContract.FoodItemEntry.COL_FOOD_TYPE, foodType);
                            values.put(FoodItemContract.FoodItemEntry.COL_QUANTITY, quantity);
                            values.put(FoodItemContract.FoodItemEntry.COL_EXPIRE_DATE, expireDate);
                            values.put(FoodItemContract.FoodItemEntry.COL_EXPIRED, 0);
                            db.insertWithOnConflict(FoodItemContract.FoodItemEntry.TABLE,
                                    null,
                                    values,
                                    SQLiteDatabase.CONFLICT_REPLACE);
                            db.close();
                            ((MainActivity)getActivity()).updateUI();
                        }
                })
                .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        AddItemDialogFragment.this.getDialog().cancel();
                    }
                });
        return builder.create();
    }
}
