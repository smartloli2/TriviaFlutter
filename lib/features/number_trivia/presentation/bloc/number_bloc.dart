import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';

part 'number_event.dart';
part 'number_state.dart';


class NumberBloc extends Bloc<NumberEvent, NumberState> {
  NumberBloc() : super(NumberInitial());
  @override
  Stream<NumberState> mapEventToState(
    NumberEvent event,
  ) async* {
    // TODO: implement mapEventToState
    
  }
}
