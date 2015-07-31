package com.epitrack.guardioes.view;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.Notice;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

public class NoticeAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private static final int POSITION_HEADER = 0;

    private static final int VIEW_AMOUNT = 1;

    private final OnNoticeListener listener;

    private final List<Notice> newsList = new ArrayList<>();

    public NoticeAdapter(final OnNoticeListener listener) {

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;

        // TODO: STUB
        final Notice news = new Notice();

        news.setTitle("Camanha de vacinação contra a gripe começa em 4 de maio, diz ministro");
        news.setSource("saude.estadao.com.br");
        news.setPublicationDate("Hoje");

        final Notice news1 = new Notice();

        news1.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news1.setSource("mundoestranho.abril.com.br");
        news1.setPublicationDate("2 dias atrás");

        final Notice news2 = new Notice();

        news2.setTitle("Ministério da Saúde convoca população para fazer teste da hepatite C");
        news2.setSource("agenciabrasil.ebc.com.br/");
        news2.setPublicationDate("4 dias atrás");

        final Notice news3 = new Notice();

        news3.setTitle("Vacinação contra gripe é estendida em Bauru e Marília");
        news3.setSource("g1.globo.com");
        news3.setPublicationDate("4 dias atrás");

        final Notice news4 = new Notice();

        news4.setTitle("Gripe aviária se espalha pela África; ONU teme contágio humano");
        news4.setSource("g1.globo.com");
        news4.setPublicationDate("5 dias atrás");

        final Notice news5 = new Notice();

        news5.setTitle("Aluno ganha medalha por remédio contra gripe à base de acerola e caju");
        news5.setSource("g1.globo.com");
        news5.setPublicationDate("6 dias atrás");

        final Notice news6 = new Notice();

        news6.setTitle("Cientistas criam vacina experimental que gera anticorpos do HIV em roedor");
        news6.setSource("g1.globo.com");
        news6.setPublicationDate("7 dias atrás");

        final Notice news7 = new Notice();

        news7.setTitle("Qual é a diferença entre gripe e resfriado?");
        news7.setSource("mundoestranho.abril.com.br");
        news7.setPublicationDate("8 dias atrás");

        final Notice news8 = new Notice();

        news8.setTitle("Qual a diferença entre febre amarela, dengue e malária?");
        news8.setSource("super.abril.com.br");
        news8.setPublicationDate("10 dias atrás");

        final Notice news9 = new Notice();

        news9.setTitle("Fio cruz inova em estudo de vacina contra a leishmaniose");
        news9.setSource("blog.saude.gov.br");
        news9.setPublicationDate("11 dias atrás");

//        final Notice news10 = new Notice();
//
//        news10.setTitle("Coreia do Sul declara extinta a epidemia do novo coronavírus");
//        news10.setSource("http://noticias.r7.com/");
//        news10.setPublicationDate("12 dias atrás");

        newsList.add(news);
        newsList.add(news1);
        newsList.add(news2);
        newsList.add(news3);
        newsList.add(news4);
        newsList.add(news5);
        newsList.add(news6);
        newsList.add(news7);
        newsList.add(news8);
        newsList.add(news9);
        //newsList.add(news10);
    }

    public static class ViewType {

        public static final int ITEM = 1;
        public static final int HEADER = 2;
    }

    public class HeaderViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.news_header_text_view_title)
        TextView textViewTitle;

        @Bind(R.id.news_header_text_view_source)
        TextView textViewSource;

        @Bind(R.id.news_header_text_view_date)
        TextView textViewDate;

        @Bind(R.id.news_header_image_view_image)
        ImageView imageViewImage;


        public HeaderViewHolder(final View view) {
            super(view);

            ButterKnife.bind(this, view);
        }
    }

    public class ItemViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.news_text_view_title)
        TextView textViewTitle;

        @Bind(R.id.news_text_view_source)
        TextView textViewSource;

        @Bind(R.id.news_text_view_date)
        TextView textViewDate;

        @Bind(R.id.news_image_view_image)
        ImageView imageViewImage;

        public ItemViewHolder(final View view) {
            super(view);

            ButterKnife.bind(this, view);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(final ViewGroup viewGroup, final int viewType) {

        final LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());

        if (viewType == ViewType.ITEM) {

            final View view = inflater.inflate(R.layout.notice_item, viewGroup, false);

            return new ItemViewHolder(view);

        } else if (viewType == ViewType.HEADER) {

            final View view = inflater.inflate(R.layout.notice_header, viewGroup, false);

            return new HeaderViewHolder(view);
        }

        throw new IllegalArgumentException("The ViewHolder has not found.");
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder viewHolder, final int position) {

        final Notice news = newsList.get(position);

        if (viewHolder instanceof HeaderViewHolder) {

            final HeaderViewHolder headerHolder = (HeaderViewHolder) viewHolder;

            headerHolder.textViewTitle.setText(news.getTitle());
            headerHolder.textViewSource.setText(news.getSource());
            headerHolder.textViewDate.setText(news.getPublicationDate());
            headerHolder.imageViewImage.setImageResource(R.drawable.stub_news);

        } else {

            final ItemViewHolder itemHolder = (ItemViewHolder) viewHolder;

            itemHolder.textViewTitle.setText(news.getTitle());
            itemHolder.textViewSource.setText(news.getSource());
            itemHolder.textViewDate.setText(news.getPublicationDate());

            if (position == 1) {
                itemHolder.imageViewImage.setImageResource(R.drawable.stub1);

            } else if (position == 2) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_1);

            } else if (position == 3) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_2);

            } else if (position == 4) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_3);

            } else if (position == 5) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_4);

            } else if (position == 6) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_5);

            } else if (position == 7) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_6);

            } else if (position == 8) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_7);

            } else if (position == 9) {
                itemHolder.imageViewImage.setImageResource(R.drawable.news_8);
            }
        }
    }

    @Override
    public int getItemViewType(final int position) {
        return position == POSITION_HEADER ? ViewType.HEADER : ViewType.ITEM;
    }

    @Override
    public int getItemCount() {
        return newsList.size();
    }
}
