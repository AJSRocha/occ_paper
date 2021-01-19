
        select p1.id id_viagem,
               p2.id id_venda,
               p3.id id_denominacao,
               p6.id id_caixa,
               p7.id id_spp,
               p9.id id_comp,
     case when rpo.desig = 'Norte' then 'NW' 
          when rpo.desig = 'Centro' then 'SW' 
          else rpo.desig end zona,
               p1.data_fin,
               p2.data data_venda,
               emb.nome nome_navio,
               emb.matricula,
               emb.cfr,
               por.nome lota,
               por.codigo_slv codporto,
     case when p1.id in (
        select x.viagem id 
          from (
        select z.viagem,
               count(*) contagem 
          from pnab.viagem_metier z 
      group by z.viagem)x 
         where x.contagem <> 1) 
          then 'MIS_MIS_0_0_0' 
          else met.desig end arte_eu,
               p2.peso_vendido,
               p4.desig cat_com,
               p5.desig denominacao,
               cast(substr(p2.data,6,2) as decimal(5,0)) mes,
               cast(substr(p2.data,1,4) as decimal(5,0)) ano,
               p3.peso_total peso_total_dom,
               p3.peso_amostrado peso_amostrado_dom,
               p3.n_caixas,
               p3.n_caixas_amostradas,
               p8.cod_fao especie_am,
               p6.peso_total peso_total_caixa,
               p6.peso_amostrado peso_am_caixa,
               p6.n_total n_total_caixa,
               p6.n_amostrados n_amostrados_caixa,
               p7.peso_total peso_total_spp,
               p7.n_total n_total_spp,
    (case when p7.peso_amostrado_comprimentos is null then 0 
          else cast(p7.peso_amostrado_comprimentos as decimal(10,2)) end)+
    (case when p7.peso_amostrado_pesos is null then 0 
          else cast(p7.peso_amostrado_pesos as decimal(10,0)) end) peso_am_spp,
    (case when p7.n_amostrado_comprimentos is null then 0 
          else cast(p7.n_amostrado_comprimentos as decimal(10,0)) end)+
		(case when p7.n_amostrado_pesos is null then 0 
		      else cast(p7.n_amostrado_pesos as decimal(10,0)) end) n_amostrado_comprimentos ,
               p7.n_machos n_machos_tot,
               p7.n_femeas n_femeas_tot,
               p7.n_indeterminados n_indeterminados_tot,
               p7.n_nao_observados n_nao_observados_tot,
               p7.peso_machos_amostr,
               p7.peso_femeas_amostr,
               p7.peso_indeterminados_amostr,
                           p9.classe_comp,p9.n_machos,p9.n_femeas,p9.n_indeterminados,p9.n_nao_observados,p9.peso_machos,p9.peso_femeas,p9.peso_indeterminados,
                           p9.peso_nao_observados
                           from pnab.viagem p1,pnab.venda p2,pnab.embarcacao emb,pnab.porto por,pnab.regiao_porto rpo,pnab.viagem_metier v_met,pnab.metier met,
                           pnab.denominacao p3,pnab.cat_comercial p4,pnab.denominacao_comercial p5,
                           pnab.caixa p6,pnab.amostra_especie p7,pnab.especie_generica p8,pnab.comprimentos p9
                           where p2.viagem=p1.id and v_met.viagem=p1.id and v_met.metier=met.id
                           and emb.id=p1.embarcacao and por.id=p2.porto and rpo.id=por.regiao and p2.id=p3.origem and p4.id=p3.cat_comercial 
                           and p5.id=p3.denominacao_comercial and p7.caixa=p6.id and p7.especie=p8.id and p9.amostra=p7.id
                           and p6.denominacao=p3.id and p3.estrat_amostragem=1
                           and p3.estrat_amostragem not in (2,3,4) and p3.cat_comercial <> 0 and p1.id not in (select viagem id from pnab.viagem_regiao where regiao <> 5) 
                           and p9.n_nao_observados is not null and p8.cod_fao='OCC' 
                           and p2.data between '2017-01-01' and '2018-12-31' 
                           UNION ALL /*ver viagens sem metier*/
                           select p1.id id_viagem,p2.id id_venda,p3.id id_denominacao,p6.id id_caixa,p7.id id_spp,p9.id id_comp,
                           case when rpo.desig = 'Norte' then 'NW' when rpo.desig = 'Centro' then 'SW' else rpo.desig end zona,
                           p1.data_fin,p2.data data_venda,emb.nome nome_navio,emb.matricula,emb.cfr,por.nome lota,por.codigo_slv codporto,
                           'MIS_MIS_0_0_0' arte_eu,p2.peso_vendido,p4.desig cat_com,p5.desig denominacao,
                           cast(substr(p2.data,6,2) as decimal(5,0)) mes,cast(substr(p2.data,1,4) as decimal(5,0)) ano,
                           p3.peso_total peso_total_dom,p3.peso_amostrado peso_amostrado_dom,p3.n_caixas,p3.n_caixas_amostradas,p8.cod_fao especie_am,
                           p6.peso_total peso_total_caixa,p6.peso_amostrado peso_am_caixa,p6.n_total n_total_caixa,p6.n_amostrados n_amostrados_caixa,
                           p7.peso_total peso_total_spp,p7.n_total n_total_spp,(case when p7.peso_amostrado_comprimentos is null then 0 else cast(p7.peso_amostrado_comprimentos as decimal(10,2)) end)+
                           (case when p7.peso_amostrado_pesos is null then 0 else cast(p7.peso_amostrado_pesos as decimal(10,0)) end) peso_am_spp,
                           (case when p7.n_amostrado_comprimentos is null then 0 else cast(p7.n_amostrado_comprimentos as decimal(10,0)) end)+
			                     (case when p7.n_amostrado_pesos is null then 0 else cast(p7.n_amostrado_pesos as decimal(10,0)) end) n_amostrado_comprimentos ,
                           p7.n_machos n_machos_tot,p7.n_femeas n_femeas_tot,p7.n_indeterminados n_indeterminados_tot,p7.n_nao_observados n_nao_observados_tot,
                           p7.peso_machos_amostr,p7.peso_femeas_amostr,p7.peso_indeterminados_amostr,
                           p9.classe_comp,p9.n_machos,p9.n_femeas,p9.n_indeterminados,p9.n_nao_observados,p9.peso_machos,p9.peso_femeas,p9.peso_indeterminados,
                           p9.peso_nao_observados
                           from pnab.viagem p1,pnab.venda p2,pnab.embarcacao emb,pnab.porto por,pnab.regiao_porto rpo,pnab.denominacao p3,pnab.cat_comercial p4,
                           pnab.denominacao_comercial p5,pnab.caixa p6,pnab.amostra_especie p7,pnab.especie_generica p8,pnab.comprimentos p9
                           where p2.viagem=p1.id and emb.id=p1.embarcacao and por.id=p2.porto and rpo.id=por.regiao and p2.id=p3.origem and p4.id=p3.cat_comercial 
                           and p5.id=p3.denominacao_comercial and p7.caixa=p6.id and p7.especie=p8.id and p9.amostra=p7.id
                           and p6.denominacao=p3.id and p3.estrat_amostragem=1
                           and p3.estrat_amostragem not in (2,3,4) and p3.cat_comercial <> 0 and p1.id not in (select viagem id from pnab.viagem_regiao where regiao <> 5) 
                           and p9.n_nao_observados is not null and p8.cod_fao='OCC' 
                           and p2.data between '2019-01-01' and '2019-12-31' 
                           and p1.id not in
                           (select distinct p1.id
                           from pnab.viagem p1,pnab.venda p2,pnab.embarcacao emb,pnab.porto por,pnab.regiao_porto rpo,pnab.viagem_metier v_met,pnab.metier met,
                           pnab.denominacao p3,pnab.cat_comercial p4,pnab.denominacao_comercial p5,
                           pnab.caixa p6,pnab.amostra_especie p7,pnab.especie_generica p8,pnab.comprimentos p9
                           where p2.viagem=p1.id and v_met.viagem=p1.id and v_met.metier=met.id
                           and emb.id=p1.embarcacao and por.id=p2.porto and rpo.id=por.regiao and p2.id=p3.origem and p4.id=p3.cat_comercial 
                           and p5.id=p3.denominacao_comercial and p7.caixa=p6.id and p7.especie=p8.id and p9.amostra=p7.id
                           and p6.denominacao=p3.id and p3.estrat_amostragem=1
                           and p3.estrat_amostragem not in (2,3,4) and p3.cat_comercial <> 0 and p1.id not in (select viagem id from pnab.viagem_regiao where regiao <> 5) 
                           and p8.cod_fao='OCC' 
                           and p2.data between '2019-01-01' and '2019-12-31')
                           UNION ALL /*juntar pesos aos comprimentos*/
                           select 
                           p0.id_viagem,p0.id_venda,p0.id_denominacao,p0.id_caixa,p0.id_spp,null id_comp,p0.zona,p0.data_fin,p0.data_venda,p0.nome_navio,p0.matricula,p0.cfr,p0.lota,p0.codporto,p0.arte_eu,
                           p0.peso_vendido,p0.cat_com,p0.denominacao,p0.mes,p0.ano,p0.peso_total_dom,p0.peso_amostrado_dom,p0.n_caixas,p0.n_caixas_amostradas,p0.especie_am,p0.peso_total_caixa,
                           p0.peso_am_caixa,p0.n_total_caixa,p0.n_amostrados_caixa,
                           p0.peso_total_spp,p0.n_total_spp,p0.peso_am_spp,p0.n_amostrado_comprimentos,p0.n_machos_tot,p0.n_femeas_tot,p0.n_indeterminados_tot,p0.n_nao_observados_tot,
                           p0.peso_machos_amostr,p0.peso_femeas_amostr,p0.peso_indeterminados_amostr,
                           p0.cclasse classe_comp,null n_machos,null n_femeas,null n_indeterminados,count(*) n_nao_observados,null peso_machos,null peso_femeas,null peso_indeterminados,
                           sum(p0.peso_total) peso_nao_observados
                           from
                           (select p1.id id_viagem,p2.id id_venda,p3.id id_denominacao,p6.id id_caixa,p7.id id_spp,p9.id id_comp,
                           case when rpo.desig = 'Norte' then 'NW' when rpo.desig = 'Centro' then 'SW' else rpo.desig end zona,
                           p1.data_fin,p2.data data_venda,emb.nome nome_navio,emb.matricula,emb.cfr,por.nome lota,por.codigo_slv codporto,
                           case when p1.id in (select x.viagem id from (select z.viagem,count(*) contagem from pnab.viagem_metier z group by z.viagem)x where x.contagem <> 1) 
                           then 'MIS_MIS_0_0_0' else met.desig end arte_eu,p2.peso_vendido,p4.desig cat_com,p5.desig denominacao,
                           cast(substr(p2.data,6,2) as decimal(5,0)) mes,cast(substr(p2.data,1,4) as decimal(5,0)) ano,
                           p3.peso_total peso_total_dom,p3.peso_amostrado peso_amostrado_dom,p3.n_caixas,p3.n_caixas_amostradas,p8.cod_fao especie_am,
                           p6.peso_total peso_total_caixa,p6.peso_amostrado peso_am_caixa,p6.n_total n_total_caixa,p6.n_amostrados n_amostrados_caixa,
                           p7.peso_total peso_total_spp,p7.n_total n_total_spp,(case when p7.peso_amostrado_comprimentos is null then 0 else cast(p7.peso_amostrado_comprimentos as decimal(10,2)) end)+
                           (case when p7.peso_amostrado_pesos is null then 0 else cast(p7.peso_amostrado_pesos as decimal(10,2)) end) peso_am_spp,
                           (case when p7.n_amostrado_comprimentos is null then 0 else cast(p7.n_amostrado_comprimentos as decimal(10,0)) end)+
			                     (case when p7.n_amostrado_pesos is null then 0 else cast(p7.n_amostrado_pesos as decimal(10,0)) end) n_amostrado_comprimentos ,
                           p7.n_machos n_machos_tot,p7.n_femeas n_femeas_tot,p7.n_indeterminados n_indeterminados_tot,p7.n_nao_observados n_nao_observados_tot,
                           p7.peso_machos_amostr,p7.peso_femeas_amostr,p7.peso_indeterminados_amostr,
                           p9.peso_total,ROUND((POWER((p9.peso_total/0.0084826085),1/2.3721375079))/10,4) comp_indiv,
                           case when (case when substr(cast(ROUND((POWER((p9.peso_total/0.0084826085),1/2.3721375079))/10,2) as character),-2,2) between 0 and 49 then 0
                           when substr(cast(ROUND((POWER((p9.peso_total/0.0084826085),1/2.3721375079))/10,2) as character),-2,2) >= 50 then 5 end)=5 then
                           substr(cast(ROUND((POWER((p9.peso_total/0.0084826085),1/2.3721375079))/10,2) as character),-5,2)+0.5 else 
                           ROUND((POWER((p9.peso_total/0.0084826085),1/2.3721375079))/10,0) end cclasse
                           from pnab.viagem p1,pnab.venda p2,pnab.embarcacao emb,pnab.porto por,pnab.regiao_porto rpo,pnab.viagem_metier v_met,pnab.metier met,
                           pnab.denominacao p3,pnab.cat_comercial p4,pnab.denominacao_comercial p5,
                           pnab.caixa p6,pnab.amostra_especie p7,pnab.especie_generica p8,pnab.individuo p9
                           where p2.viagem=p1.id and v_met.viagem=p1.id and v_met.metier=met.id
                           and emb.id=p1.embarcacao and por.id=p2.porto and rpo.id=por.regiao and p2.id=p3.origem and p4.id=p3.cat_comercial 
                           and p5.id=p3.denominacao_comercial and p7.caixa=p6.id and p7.especie=p8.id and p9.amostra=p7.id
                           and p6.denominacao=p3.id and p3.estrat_amostragem=1
                           and p3.estrat_amostragem not in (2,3,4) and p3.cat_comercial <> 0 and p1.id not in (select viagem id from pnab.viagem_regiao where regiao <> 5) 
                           and p8.cod_fao='OCC' 
                           and p2.data between '2019-01-01' and '2019-12-31' 
                           )p0
                           group by p0.id_viagem,p0.id_venda,p0.id_denominacao,p0.id_caixa,p0.id_spp,null,p0.zona,p0.data_fin,p0.data_venda,p0.nome_navio,p0.matricula,p0.cfr,p0.lota,p0.codporto,p0.arte_eu,
                           p0.peso_vendido,p0.cat_com,p0.denominacao,p0.mes,p0.ano,p0.peso_total_dom,p0.peso_amostrado_dom,p0.n_caixas,p0.n_caixas_amostradas,p0.especie_am,p0.peso_total_caixa,
                           p0.peso_am_caixa,p0.n_total_caixa,p0.n_amostrados_caixa,
                           p0.peso_total_spp,p0.n_total_spp,p0.peso_am_spp,p0.n_amostrado_comprimentos,p0.n_machos_tot,p0.n_femeas_tot,p0.n_indeterminados_tot,p0.n_nao_observados_tot,
                           p0.peso_machos_amostr,p0.peso_femeas_amostr,p0.peso_indeterminados_amostr,
                           p0.cclasse,null,null,null,null,null,null