clear

N = 20; %board size
maximum_colisions = N * (N-1)/2
pop_size = 50;
gen_number = 51;
population  = zeros(pop_size, N);
fitness = [pop_size];
mutation_probability = 0.2;
parents_considered = 5;
optimal_solution = 0;
gen_count = 2;
generation_most_fit = zeros(1,gen_number -1);
generation_median = zeros(1,gen_number -1);

% First random generation eneration
for j = 1:pop_size
    population(j,:) = randperm(N);
    fitness(j) = fitness_nq(population(j,:));
end

 generation_most_fit(1) = fitness(1);

% Sorting the new generation according to the fitness
[~,fitnessSort]=sort(fitness);
sorted_population = population(fitnessSort,:);

generation(1,:,:) = sorted_population;
generation_fitness(1,:) = fitness;
generation_median(1) = median(fitness);

while(gen_count < gen_number)
%     Getting 5 parents and choosing the two best
    parents_index = sort(randperm(pop_size, 5));
    parents(1,:) = (population(parents_index(1),:));
    parents(2,:) = (population(parents_index(2),:));
    
%    Matting the parents
    children = CutAndCrossfill_Crossover(parents);
    
%     Mutating the children
    if(mutation_probability > rand())
        children(round(rand() + 1), ceil(N * rand())) = ceil(N * rand());
    end

%     Adding children to new generation
    new_generation = sorted_population;
    new_generation(pop_size+1,:) = children(1,:);
    new_generation(pop_size+2,:) = children(2,:);

%     Getting the fitness of the new children
    fitness(pop_size+1) = fitness_nq(children(1,:));
    fitness(pop_size+2) = fitness_nq(children(2,:));

%     Sorting the new generation 
    [sorted_fitness,fitnessSort]=sort(fitness);
    fitness = sorted_fitness(1:end-2);
    new_generation = new_generation(fitnessSort,:);

%     Removing the 2 worst individuals of the new generation
    new_generation = new_generation(1:end-2, :);
    
%     Add to generation and generation fitness history
    generation(gen_count,:,:) = new_generation;
    generation_fitness(gen_count,:) = fitness;
    generation_median(gen_count) = median(fitness);
    generation_most_fit(gen_count) = fitness(1);
    
    gen_count = gen_count + 1
end

% Plots

figure(1)
stem(generation_median);
hold on
stem(generation_most_fit)
hold off
figure(2)
x = categorical({'10', '20', '50'});
bar(x,[generation_median(10), generation_median(20), generation_median(50)],'FaceColor',[0 .5 .5])
hold on
bar(x,[generation_most_fit(10), generation_most_fit(20), generation_most_fit(50)])
hold off