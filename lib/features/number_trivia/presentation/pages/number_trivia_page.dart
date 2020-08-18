import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_learn/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'package:tdd_learn/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:tdd_learn/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:tdd_learn/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:tdd_learn/features/number_trivia/presentation/widgets/trivia_display.dart';

import '../../../../injection_container.dart';



class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
      
    );
  }

  

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          
          // Colomn
          child: Column(
            children: <Widget>[
              // Empty space
              SizedBox(
                height: 10
              ),

              // Top block
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } 
                  else if (state is Loading) {
                     return LoadingWidget();
                  } 
                  else if (state is Loaded) {
                      return TriviaDisplay(
                          numberTrivia: state.trivia,
                      );
                  } 
                  else if (state is Error) {
                      return MessageDisplay(
                        message: state.message,
                      );
                  }
                  return Container();
                },
              ),

              // Empty space
              SizedBox(
                height: 20
              ),

              // Bottom block
              TriviaControls(),
              // Column
              /*Column(
                children: <Widget>[
                  // TextField
                  Placeholder(fallbackHeight: 40),

                  // Empty space
                  SizedBox(height: 10),
                  
                  // Row of buttons
                  Row(
                    children: <Widget>[
                      // Search concrete button
                      Expanded(
                        child: Placeholder(fallbackHeight: 30),
                      ),

                      // Empty space
                      SizedBox(width: 10),

                      // Random button
                      Expanded(
                        child: Placeholder(fallbackHeight: 30),
                      )
                    ],
                  )

                ],
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

