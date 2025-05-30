// RUN: mlir-opt %s -test-lower-to-llvm  | \
// RUN: mlir-runner -e entry -entry-point-result=void  \
// RUN:   -shared-libs=%mlir_c_runner_utils | \
// RUN: FileCheck %s

func.func @entry() {
  %cneg1 = arith.constant -1 : index
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c3 = arith.constant 3 : index
  %c6 = arith.constant 6 : index
  %c7 = arith.constant 7 : index

  //
  // 1-D.
  //

  %1 = vector.create_mask %c2 : vector<5xi1>
  vector.print %1 : vector<5xi1>
  // CHECK: ( 1, 1, 0, 0, 0 )

  scf.for %i = %cneg1 to %c7 step %c1 {
    %2 = vector.create_mask %i : vector<5xi1>
    vector.print %2 : vector<5xi1>
  }
  // CHECK: ( 0, 0, 0, 0, 0 )
  // CHECK: ( 0, 0, 0, 0, 0 )
  // CHECK: ( 1, 0, 0, 0, 0 )
  // CHECK: ( 1, 1, 0, 0, 0 )
  // CHECK: ( 1, 1, 1, 0, 0 )
  // CHECK: ( 1, 1, 1, 1, 0 )
  // CHECK: ( 1, 1, 1, 1, 1 )
  // CHECK: ( 1, 1, 1, 1, 1 )

  //
  // 2-D.
  //

  %3 = vector.create_mask %c2, %c3 : vector<5x5xi1>
  vector.print %3 : vector<5x5xi1>
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )

  %4 = vector.create_mask %c3, %c2 : vector<5x5xi1>
  vector.print %4 : vector<5x5xi1>
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )

  scf.for %i = %c0 to %c6 step %c1 {
    %5 = vector.create_mask %c2, %i : vector<5x5xi1>
    vector.print %5 : vector<5x5xi1>
  }
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )

  scf.for %i = %c0 to %c6 step %c1 {
    %6 = vector.create_mask %i, %c2 : vector<5x5xi1>
    vector.print %6 : vector<5x5xi1>
  }
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ) )

  scf.for %i = %c0 to %c6 step %c1 {
    scf.for %j = %c0 to %c6 step %c1 {
      %7 = vector.create_mask %i, %j : vector<5x5xi1>
      vector.print %7 : vector<5x5xi1>
    }
  }
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 1 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ), ( 0, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ), ( 1, 0, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ), ( 1, 1, 0, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ), ( 1, 1, 1, 0, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ), ( 1, 1, 1, 1, 0 ) )
  // CHECK: ( ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ), ( 1, 1, 1, 1, 1 ) )

  return
}
