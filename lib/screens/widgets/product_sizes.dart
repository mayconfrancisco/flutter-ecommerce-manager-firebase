import 'package:ecommerce_manager_flutter/screens/widgets/add_size_dialog.dart';
import 'package:flutter/material.dart';

class ProductSizes extends FormField<List> {
  ProductSizes(
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  ) : super(
            initialValue: initialValue != null ? initialValue : [],
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34,
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.5,
                          crossAxisCount: 1,
                          mainAxisSpacing: 8),
                      children: state.value
                          .map<Widget>((size) => GestureDetector(
                                onLongPress: () {
                                  state.didChange(state.value..remove(size));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                      border: Border.all(
                                          color: Colors.pinkAccent, width: 3)),
                                  child: Text(
                                    size,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ))
                          .toList()
                            ..add(GestureDetector(
                              onTap: () async {
                                String size = await showDialog(
                                  context: context,
                                  builder: (context) => AddSizeDialog(),
                                );
                                if (size != null && size.isNotEmpty) {
                                  state.didChange(state.value..add(size));
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    border: Border.all(
                                        color: state.hasError
                                            ? Colors.red
                                            : Colors.pinkAccent,
                                        width: 3)),
                                child: Text(
                                  "+",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : const SizedBox(),
                ],
              );
            });
}
