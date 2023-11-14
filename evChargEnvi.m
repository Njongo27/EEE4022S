classdef evChargEnvi < rl.env.MATLABEnvironment
    properties
        % Environment properties
        evChargStation
        evChargCosts
        EV
    end

    methods
        function envrnmnt = evChargEnvi()
            % Define the observation space
            ObsInfo = rlNumericSpec([3 1]);
            ActInfo = rlFiniteSetSpec([0.214336894120312,0.224094222424965,0.211013638684774,0.204047660773392,0.197832839205750,0.188401387689405,0.184082814256795,0.177227535507627,0.172513874029267,0.173168992988960,0.166905251844651,0.164763120498104,0.166977040946110,0.164431195397558,0.164367748487743,0.162779741782972,0.160785310968228,0.160659127086875,0.159715609472374,0.159550819970436,0.158433343913512,0.156067178006198,0.157138451336915,0.158232158174268,0.161444599889052,0.164032940786088,0.164826891228512,0.166125887843216,0.166182763123587,0.161085060027474,0.162012693846128,0.161220302728168,0.156875455425558,0.151547064899400,0.148882285741565,0.147779315878716,0.142568166512683,0.138661807938220,0.137947970560983,0.141761549760838,0.145507607649804,0.149354126079616,0.152891516344952,0.156357552047558,0.159903248393174,0.163278912029427,0.166123699204958,0.167423481425224,0.169501013897136,0.173434211959342,0.177120526008940,0.180622386977091,0.183507090792441,0.186251133802595,0.188070474783761,0.187917538251392,0.187460019351969,0.186558566755554,0.185558720485464,0.184294277075700,0.181845017512969,0.178109116810337,0.174933739662070,0.185426727217755,0.190476640911737,0.193958724648825,0.209159654507224,0.220812742883028,0.227274466904667,0.244476608488491,0.253287295196559,0.261204789617449,0.269873651168486,0.270706148879958,0.263802943972569,0.267164275049031,0.267201410268186,0.258345791235977,0.253910235046269,0.248272767495874,0.238504143027052,0.238954623479842,0.230936830011621,0.220034324150928,0.220687879830619,0.215713841201352,0.206320464237899,0.202254493058979,0.200234416858335,0.196590931703844,0.199069273584596,0.200956392661126,0.188444847938494,0.187524475867246,0.173498989718470,0.162146693257126]);            
            envrnmnt = envrnmnt@rl.env.MATLABEnvironment(ObsInfo, ActInfo);
            ObsInfo.Name = 'EV charging observation';
            ObsInfo.Description = 'Charging demand, Time of the day, Pricing, Availability of charging';
            envrnmnt.ObservationInfo = ObsInfo;
            
            % Define the action space
            ActInfo.Name = 'Multiplier';
            ActInfo.Description = 'Action';
            envrnmnt.ActionInfo = ActInfo;
            
            % Initialize the charging station, ChargingCosts, and EV
            envrnmnt.evChargStation = chargStation();
            envrnmnt.EV = elecVehicle();
            envrnmnt.evChargCosts = zeros(1, 0); % Create an empty array for charging costs
        end

        function [Obs, reward, isDone] = step(envrnmnt, Action)
            % Implement a step function for the environment dynamics
            % Obtain observations from charging station and EV
            ChargStationObs = envrnmnt.evChargStation.observe();
            evObs = envrnmnt.EV.observe();

            % Combine observations
            Obs = [evObs; ChargStationObs];

            % Apply agent's pricing action
            envrnmnt.evChargStation.amendPricing(Action);

            % Simulate one step in the EV charging process
            envrnmnt.EV.charge();

            % Calculate reward
            reward = -Action / (ChargStationObs(1) + 0.001);

            % Calculate and update ChargingCosts
            chargCost = Action * ChargStationObs(1);
            envrnmnt.evChargCosts(end+1) = chargCost;

            % Check if episode is done
            isDone = (evObs(1) >= 0.9);
        end

        function InitObs = reset(envrnmnt)
            % Reset the charging station, EV, and ChargingCosts
            envrnmnt.evChargStation.reset();
            envrnmnt.EV.reset();
            envrnmnt.evChargCosts = zeros(1, 0); % Reset evChargingCosts

            % Obtain initial observations
            ChargStationObs = envrnmnt.evChargStation.observe();
            evObs = envrnmnt.EV.observe();

            % Combine observations
            InitObs = [evObs; ChargStationObs];
        end

        % Save charging costs
        function saveChargCosts(envrnmnt)
            % load timePred.mat;
            % figure;
            % plot(timePred(1:96),this.ChargingCosts, 'r', 'LineWidth', 2);
            % title('EV Charging Costs (RTP)');
            % xlabel('Time of Day');
            % ylabel('Charging Cost ($/kWh)');
            % Save charging costs
            costs = table(envrnmnt.evChargCosts);
            filename = 'rtpDQNCosts.xlsx';
            writetable(costs,filename,'Sheet',1,'Range','A2');
        end
    end
end
