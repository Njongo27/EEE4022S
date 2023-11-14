classdef elecVehicle
    properties
        SOC
    end

    methods
        function theEV = elecVehicle()
            % Initialize EV
            theEV.SOC = 0.2; % Initial state of charge to 20%
        end

        function obs = observe(theEV)
            % Return observation of EV SOC
            obs = [theEV.SOC];
        end

        function charge(theEV)
            % Simulate one step of EV charging
            % Adjust state of charge
            theEV.SOC = theEV.SOC + 0.1;
        end

        function reset(theEV)
            % Reset the electric vehicle to initial state
            theEV.SOC = 0.2; % Reset state of charge back to 20%
        end
    end
end
