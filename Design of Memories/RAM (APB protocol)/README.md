Ref https://kumarrishav14.github.io/AMBA_APB/

# SV Testbench
<img width="1006" height="715" alt="APB_TB_arch" src="https://github.com/user-attachments/assets/2101b36e-d62c-4e88-be1a-3823b0979070" />

> Fig. 1: Testbench Architecture

## Components
### Transaction
Signals encapsulated in transaction class is shown below:

```sv
class transaction;
    // Input
    rand bit PWRITE;          
    rand bit[31:0] PWDATA [];   
    rand bit[31:0] PADDR [];   
    rand bit PRESETn;    
    bit PSEL1;
    bit PENABLE;

    // Output
    bit PREADY;
    bit [31:0] PRDATA [int];
    bit PSLVERR;
endclass
```

Transaction class also encapsulates helper function like printf(string message), compare(transaction trans), etc.

### Generator
Generates new packet which is sent to the driver. Main functionality is to randomize transaction class.

```sv
task run();
    assert(trans.randomize());
endtask
```

### Driver
Drives the packet according to the APB protocol. The drive seqeunce is as follows:

<img width="433" height="776" alt="driver" src="https://github.com/user-attachments/assets/e09ad923-7eff-43a5-b7e1-cba2c1304ee2" />

> Fig. 2: Driver Flow

### Input Monitor
Monitors the input signals of the APB protocol and when a complete transaction is monitored, it sends the sampled packet to reference model, which generates the expected value.

### Output Monitor
Monitors the output signals of the APB protocol and after complete transaction is monitored it sends the packet to scoreboard for checking.

### Reference Model
Generates the reference output/value, which is compared with the actual output received from the DUT

### Scoreboard
Compares the actual packet and the reference packet and generates report for all the test cases.

# UVM Testbench
<img width="1006" height="715" alt="APB_TB_arch" src="https://github.com/user-attachments/assets/cff2324b-cbd8-4cf5-b65d-eb1830c33ec6" />


