clc;
clear;

%% --- Column Buckling Calculator ---

%% 1. User Input
E = input("Enter Modulus of Elasticity, E (Pa): ");
L = input("Enter the actual length of the column, L (m): ");
FOS = input("Enter the Factor of Safety (1.4 to 3.0): ");

%% 2. Cross-Section Geometry
disp(" ");
disp("Select the cross-section shape:");
disp("1: Rectangular");
disp("2: Circular");
shape_choice = input("Enter choice (1-2): ");

switch shape_choice
    case 1
        b = input("Enter width b (m): ");
        h = input("Enter height h (m): ");
        A = b * h;
        I = min((b*h^3)/12, (h*b^3)/12);

    case 2
        d = input("Enter diameter d (m): ");
        A = (pi*d^2)/4;
        I = (pi*d^4)/64;

    otherwise
        error("Invalid shape selection");
end

%% 3. Support Condition
disp(" ");
disp("Select support condition:");
disp("1: Both ends pinned (K=1)");
disp("2: One fixed, one free (K=2)");
disp("3: One fixed, one pinned (K=0.7)");
disp("4: Both fixed (K=0.5)");
choice = input("Enter choice (1-4): ");

switch choice
    case 1
        K = 1;
    case 2
        K = 2;
    case 3
        K = 0.7;
    case 4
        K = 0.5;
    otherwise
        K = 1;
end

%% 4. Calculations
Le = K * L;
r = sqrt(I/A);
slenderness_ratio = Le / r;

P_cr = (pi^2 * E * I) / (Le^2);
stress_cr = P_cr / A;

P_allow = P_cr / FOS;
stress_allow = stress_cr / FOS;

%% 5. Results
disp(" ");
disp("--- Results ---");
disp("Area = " + round(A,6) + " m^2");
disp("Moment of Inertia = " + sprintf('%.2e',I) + " m^4");
disp("Effective Length = " + round(Le,2) + " m");
disp("Slenderness Ratio = " + round(slenderness_ratio,2));

disp("Critical Load = " + round(P_cr/1000,2) + " kN");
disp("Allowable Load = " + round(P_allow/1000,2) + " kN");

%% 6. GRAPH

figure;

% Graph 1: Length vs Load
subplot(2,1,1);
L_range = linspace(0.5,10,100);
P_range = (pi^2 * E * I) ./ (K .* L_range).^2;

plot(L_range, P_range/1000, 'b', 'LineWidth', 2);
hold on;
plot(L, P_cr/1000, 'ro', 'MarkerFaceColor', 'r');
grid on;

title('Length vs Critical Load');
xlabel('Length (m)');
ylabel('Load (kN)');
legend('Curve','Your Input');

% Graph 2: Slenderness vs Stress
subplot(2,1,2);
SR_range = linspace(10,200,100);
Stress_range = (pi^2 * E) ./ (SR_range.^2);

plot(SR_range, Stress_range/1e6, 'g', 'LineWidth', 2);
hold on;
plot(slenderness_ratio, stress_cr/1e6, 'ko', 'MarkerFaceColor', 'k');
grid on;

title('Slenderness vs Stress');
xlabel('Slenderness Ratio');
ylabel('Stress (MPa)');
legend('Curve','Your Column');

sgtitle('Column Buckling Analysis');